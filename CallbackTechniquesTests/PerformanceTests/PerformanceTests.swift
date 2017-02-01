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
    
    PerformanceTestQueue()
      .measurePerformanceOfDelegate()
      .measurePerformanceOfNotificationCenter()
      .measurePerformanceOfClosureAndBlock()
      .measurePerformanceOfInvocation()
      .measurePerformanceOfResponder()
      .measurePerformanceOfKeyValueObserving()
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
  
  var iterations: Int {
    return 10000
  }
  
  // MARK: - Delegate
  
  func measurePerformanceOfDelegate() -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Delegate]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = SwiftDelegateCallee()
            let caller = SwiftDelegateCaller()
            caller.delegate = callee
            let test: VoidClosure = { _ in
              caller.callDelegate()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Delegate]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = ObjCDelegateCallee()
            let caller = ObjCDelegateCaller()
            caller.delegate = callee
            let test: VoidClosure = { _ in
              caller.callDelegate()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
  }
  
  // MARK: - NotificationCenter
  
  func measurePerformanceOfNotificationCenter() -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: NotificationCenter]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = SwiftNotificationCenterCallee()
            let caller = SwiftNotificationCenterCaller()
            callee.subscribe()
            let test: VoidClosure = { _ in
              caller.postNotification()
            }
            let tearDown: VoidClosure = { _ in
              callee.unsubscribe()
            }
            return (test: test, tearDown: tearDown)
          }
          .printResults()
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: NotificationCenter]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = ObjCNotificationCenterCallee()
            let caller = ObjCNotificationCenterCaller()
            callee.subscribe()
            let test: VoidClosure = { _ in
              caller.postNotification()
            }
            let tearDown: VoidClosure = { _ in
              callee.unsubscribe()
            }
            return (test: test, tearDown: tearDown)
          }
          .printResults()
      }
  }
  
  // MARK: - Closure/Block
  
  func measurePerformanceOfClosureAndBlock() -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Closure]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = SwiftClosureCallee()
            let caller = SwiftClosureCaller()
            caller.closure = callee.callback()
            let test: VoidClosure = { _ in
              caller.performClosure()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Block]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = ObjCBlockCallee()
            let caller = ObjCBlockCaller()
            caller.block = callee.callback()
            let test: VoidClosure = { _ in
              caller.callBlock()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
  }
  
  // MARK: - Invocation
  
  func measurePerformanceOfInvocation() -> PerformanceTestQueue {
    
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Invocation]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = ObjCInvocationCallee()
            let caller = ObjCInvocationCaller()
            caller.setTarget(callee, selector: #selector(ObjCInvocationCallee.invocationHandler))
            let test: VoidClosure = { _ in
//              caller.invoke()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
  }
  
  // MARK: - Responder
  
  func measurePerformanceOfResponder() -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: Responder]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = SwiftResponderCallee()
            let caller = SwiftResponderCaller()
            callee.addSubview(caller)
            let test: VoidClosure = { _ in
              caller.triggerResponderChain()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: Responder]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = ObjCResponderCallee()
            let caller = ObjCResponderCaller()
            callee.addSubview(caller)
            let test: VoidClosure = { _ in
              caller.triggerResponderChain()
            }
            return (test: test, tearDown: nil)
          }
          .printResults()
      }
  }
  
  // MARK: - KeyValueObserving
  
  func measurePerformanceOfKeyValueObserving() -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Swift: KeyValueObserving]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = SwiftKeyValueObservingCallee()
            let caller = SwiftKeyValueObservingCaller()
            callee.startObserving(object: caller)
            let test: VoidClosure = { _ in
              caller.changeValue()
            }
            let tearDown: VoidClosure = { _ in
              callee.stopObserving(object: caller)
            }
            return (test: test, tearDown: tearDown)
          }
          .printResults()
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(subject: "[Obj-C: KeyValueObserving]", iterations: self.iterations)
          .launch { () -> (test: VoidClosure, tearDown: VoidClosure?) in
            let callee = ObjCKeyValueObservingCallee()
            let caller = ObjCKeyValueObservingCaller()
            callee.startObserving(caller)
            let test: VoidClosure = { _ in
              caller.changeValue()
            }
            let tearDown: VoidClosure = { _ in
              callee.stopObserving(caller)
            }
            return (test: test, tearDown: tearDown)
          }
          .printResults()
      }
  }
}
