//
//  CallbacksPerformanceTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//


class CallbacksPerformanceTests: XCTestCase {
  
  func testPerformanceOfCallbackTechniques() {
    
    let queueExpectation = expectation(description: "Queue expectation")
    
    let syncTestIterations = 100000
    let asyncTestIterations = 4000
    
    let testCompletion = { (title: Any, iterations: Int, nanosec: TimeUnit) in
      print("\(title) average time: \(nanosec)ns (\(TimeInterval(nanosec) / 1_000_000)ms)")
    }
    
    PerformanceTestQueue(testCompletion: testCompletion)
      .measurePerformanceTestsOverhead(syncTestIterations: syncTestIterations,
                                       asyncTestIterations: asyncTestIterations)
      .measurePerformanceOfDelegate(iterations: syncTestIterations)
      .measurePerformanceOfNotificationCenter(iterations: syncTestIterations)
      .measurePerformanceOfClosureAndBlock(iterations: syncTestIterations)
      .measurePerformanceOfInvocation(iterations: syncTestIterations)
      .measurePerformanceOfResponder(iterations: syncTestIterations)
      .measurePerformanceOfKeyValueObserving(iterations: syncTestIterations)
      .measurePerformanceOfTask(iterations: asyncTestIterations)
      .measurePerformanceOfPromisesAndFutures(iterations: asyncTestIterations)
      .measurePerformanceOfEvents(iterations: syncTestIterations)
      .measurePerformanceOfStreamOfValues(iterations: syncTestIterations)
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
  
  // MARK: - Overhead
  
  func measurePerformanceTestsOverhead(syncTestIterations: Int, asyncTestIterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Sync test overhead]", iterations: syncTestIterations, type: .overheadMeasurement)
          .setup { () -> RunSyncTestClosure in
            return { _ in }
        }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Async test overhead]", iterations: asyncTestIterations, type: .overheadMeasurement)
          .setup { () -> RunAsyncTestClosure in
            return { completion -> Void in
              completion()
            }
        }
    }
  }
  
  // MARK: - Delegate
  
  func measurePerformanceOfDelegate(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: Delegate]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftDelegateCallee()
            let caller = SwiftDelegateCaller()
            caller.delegate = callee
            return { _ in
              caller.callDelegate()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Obj-C: Delegate]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
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
        return PerformanceTest(title: "[Swift: NotificationCenter]", iterations: iterations)
          .setup { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
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
        return PerformanceTest(title: "[Obj-C: NotificationCenter]", iterations: iterations)
          .setup { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
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
        return PerformanceTest(title: "[Swift: Closure]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftClosureCallee()
            let caller = SwiftClosureCaller()
            caller.closure = callee.callback()
            return { _ in
              caller.performClosure()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Obj-C: Block]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
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
        return PerformanceTest(title: "[Obj-C: Invocation]", iterations: iterations)
          .setup { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
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
        return PerformanceTest(title: "[Swift: Responder]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftResponderCallee()
            let caller = SwiftResponderCaller()
            callee.addSubview(caller)
            return { _ in
              caller.triggerResponderChain()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Obj-C: Responder]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = ObjCResponderCallee()
            let caller = ObjCResponderCaller()
            callee.addSubview(caller)
            return { _ in
              caller.triggerResponderChain()
            }
          }
      }
  }
  
  // MARK: - Key Value Observing
  
  func measurePerformanceOfKeyValueObserving(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: KeyValueObserving]", iterations: iterations)
          .setup { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
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
        return PerformanceTest(title: "[Obj-C: KeyValueObserving]", iterations: iterations)
          .setup { () -> (test: RunSyncTestClosure, tearDown: TearDownClosure) in
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
  
  // MARK: - Task
  
  func measurePerformanceOfTask(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: NSOperation]", iterations: iterations)
          .setup { () -> RunAsyncTestClosure in
            let callee = SwiftOperationCallee()
            let caller = SwiftOperationCaller()
            let operationQueue = OperationQueue()
            operationQueue.isSuspended = true
            let callerOperation = caller.operation()
            let calleeOperation = callee.operation(awaiting: callerOperation)
            operationQueue.addOperation(calleeOperation)
            operationQueue.addOperation(callerOperation)
            return { completion -> Void in
              calleeOperation.completionBlock = completion
              operationQueue.isSuspended = false
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Obj-C: NSOperation]", iterations: iterations)
          .setup { () -> RunAsyncTestClosure in
            let callee = ObjCOperationCallee()
            let caller = ObjCOperationCaller()
            let operationQueue = OperationQueue()
            operationQueue.isSuspended = true
            let callerOperation = caller.operation()!
            let calleeOperation = callee.operationAwaiting(callerOperation)!
            operationQueue.addOperation(calleeOperation)
            operationQueue.addOperation(callerOperation)
            return { completion -> Void in
              calleeOperation.completionBlock = completion
              operationQueue.isSuspended = false
            }
          }
      }
  }
  
  // MARK: - Promises and Futures
  
  func measurePerformanceOfPromisesAndFutures(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: PromiseKit]", iterations: iterations)
          .setup { () -> RunAsyncTestClosure in
            let caller = SwiftPromiseKitCaller()
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
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: BrightFutures]", iterations: iterations)
          .setup { () -> RunAsyncTestClosure in
            let caller = SwiftBrightFuturesCaller()
            var promiseFulfillment: VoidClosure!
            _ = caller.provideFuture().andThen { _ in
              promiseFulfillment()
            }
            return { completion -> Void in
              promiseFulfillment = completion
              caller.resolve()
            }
          }
      }
  }
  
  // MARK: - Event
  
  func measurePerformanceOfEvents(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: Signals]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftSignalsEventCallee()
            let caller = SwiftSignalsEventCaller()
            callee.observe(event: caller.event)
            return { _ in
              caller.triggerEvent()
              _ = callee
            }
        }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: EmitterKit]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftEmitterKitEventCallee()
            let caller = SwiftEmitterKitEventCaller()
            callee.observe(event: caller.event)
            return { _ in
              caller.triggerEvent()
              _ = callee
            }
        }
      }
  }
  
  // MARK: - Stream of Values
  
  func measurePerformanceOfStreamOfValues(iterations: Int) -> PerformanceTestQueue {
    return self
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: RxSwift]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftRxSwiftCallee()
            let caller = SwiftRxSwiftCaller()
            callee.observe(stream: caller.stream)
            return { _ in
              caller.generateEvent()
            }
          }
      }
      .enqueue { () -> PerformanceTest in
        return PerformanceTest(title: "[Swift: ReactiveSwift]", iterations: iterations)
          .setup { () -> RunSyncTestClosure in
            let callee = SwiftReactiveSwiftCallee()
            let caller = SwiftReactiveSwiftCaller()
            callee.observe(stream: caller.stream)
            return { _ in
              caller.generateEvent()
            }
          }
      }
  }
}
