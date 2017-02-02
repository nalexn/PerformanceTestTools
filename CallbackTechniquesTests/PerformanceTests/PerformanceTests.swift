//
//  PerformanceTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//


class PerformanceTests: XCTestCase {
  
  func testPerformance() {
    
    let queueExpectation = expectation(description: "Queue expectation")
    
    let defaultNumber = 100000
    
    PerformanceTestQueue()
      .measurePerformanceOfDelegate(iterations: defaultNumber)
      .measurePerformanceOfNotificationCenter(iterations: defaultNumber)
      .measurePerformanceOfClosureAndBlock(iterations: defaultNumber)
      .measurePerformanceOfInvocation(iterations: defaultNumber)
      .measurePerformanceOfResponder(iterations: defaultNumber)
      .measurePerformanceOfKeyValueObserving(iterations: defaultNumber)
      .measurePerformanceOfPromise(iterations: 3000)
      .finally {
        queueExpectation.fulfill()
      }
    
    waitForExpectations(timeout: 30) { error in
      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }
}

extension PerformanceTestQueue {
  
  // MARK: - Delegate
  
  func measurePerformanceOfDelegate(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Delegate]", iterations: iterations)
          .launch { () -> RunSyncTestClosure in
            let callee = SwiftDelegateCallee()
            let caller = SwiftDelegateCaller()
            caller.delegate = callee
            return { _ in
              caller.callDelegate()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Delegate]", iterations: iterations)
          .launch { () -> RunSyncTestClosure in
            let callee = ObjCDelegateCallee()
            let caller = ObjCDelegateCaller()
            caller.delegate = callee
            return { _ in
              caller.callDelegate()
            }
          }
      }
  }
  
  // MARK: - NotificationCenter
  
  func measurePerformanceOfNotificationCenter(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: NotificationCenter]", iterations: iterations)
          .launch { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
            let callee = SwiftNotificationCenterCallee()
            let caller = SwiftNotificationCenterCaller()
            callee.subscribe()
            let test: RunSyncTestClosure = { _ in
              caller.postNotification()
            }
            let tearDown: TearDownClosure = { _ in
              callee.unsubscribe()
            }
            return (test: test, tearDown: tearDown)
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: NotificationCenter]", iterations: iterations)
          .launch { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
            let callee = ObjCNotificationCenterCallee()
            let caller = ObjCNotificationCenterCaller()
            callee.subscribe()
            let test: RunSyncTestClosure = { _ in
              caller.postNotification()
            }
            let tearDown: TearDownClosure = { _ in
              callee.unsubscribe()
            }
            return (test: test, tearDown: tearDown)
          }
      }
  }
  
  // MARK: - Closure/Block
  
  func measurePerformanceOfClosureAndBlock(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Closure]", iterations: iterations)
          .launch { () -> RunSyncTestClosure in
            let callee = SwiftClosureCallee()
            let caller = SwiftClosureCaller()
            caller.closure = callee.callback()
            return { _ in
              caller.performClosure()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Block]", iterations: iterations)
          .launch { () -> RunSyncTestClosure in
            let callee = ObjCBlockCallee()
            let caller = ObjCBlockCaller()
            caller.block = callee.callback()
            return { _ in
              caller.callBlock()
            }
          }
      }
  }
  
  // MARK: - Invocation
  
  func measurePerformanceOfInvocation(iterations: Int) -> PerformanceTestQueue {
    
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Invocation]", iterations: iterations)
          .launch { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
            let callee = ObjCInvocationCallee()
            let caller = ObjCInvocationCaller()
            callee.add(to: caller)
            let test: RunSyncTestClosure = { _ in
              caller.invoke()
            }
            let tearDown: TearDownClosure = { _ in
              callee.remove(from: caller)
            }
            return (test: test, tearDown: tearDown)
          }
      }
  }
  
  // MARK: - Responder
  
  func measurePerformanceOfResponder(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Responder]", iterations: iterations)
          .launch { () -> RunSyncTestClosure in
            let callee = SwiftResponderCallee()
            let caller = SwiftResponderCaller()
            callee.addSubview(caller)
            return { _ in
              caller.triggerResponderChain()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Responder]", iterations: iterations)
          .launch { () -> RunSyncTestClosure in
            let callee = ObjCResponderCallee()
            let caller = ObjCResponderCaller()
            callee.addSubview(caller)
            return { _ in
              caller.triggerResponderChain()
            }
          }
      }
  }
  
  // MARK: - KeyValueObserving
  
  func measurePerformanceOfKeyValueObserving(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: KeyValueObserving]", iterations: iterations)
          .launch { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
            let callee = SwiftKeyValueObservingCallee()
            let caller = SwiftKeyValueObservingCaller()
            callee.startObserving(object: caller)
            let test: RunSyncTestClosure = { _ in
              caller.changeValue()
            }
            let tearDown: TearDownClosure = { _ in
              callee.stopObserving(object: caller)
            }
            return (test: test, tearDown: tearDown)
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: KeyValueObserving]", iterations: iterations)
          .launch { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
            let callee = ObjCKeyValueObservingCallee()
            let caller = ObjCKeyValueObservingCaller()
            callee.startObserving(caller)
            let test: RunSyncTestClosure = { _ in
              caller.changeValue()
            }
            let tearDown: TearDownClosure = { _ in
              callee.stopObserving(caller)
            }
            return (test: test, tearDown: tearDown)
          }
      }
  }
  
  // MARK: - Promise
  
  func measurePerformanceOfPromise(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Promise]", iterations: iterations)
          .launch { () -> RunAsyncTestClosure in
            let caller = SwiftPromiseCaller()
            var promiseFulfillment: VoidClosure!
            _ = caller.givePromise().then { _ in
              promiseFulfillment()
            }
            return { completion -> Void in
              promiseFulfillment = completion
              caller.fulfillPromise()
            }
          }
      }
  }
}
