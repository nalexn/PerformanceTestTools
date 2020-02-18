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
            return { }
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
            return {
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
            return {
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
            let test: RunSyncTestClosure = {
              caller.postNotification()
            }
            let tearDown: TearDownClosure = {
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
            let test: RunSyncTestClosure = {
              caller.postNotification()
            }
            let tearDown: TearDownClosure = {
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
            return {
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
            return {
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
            let test: RunSyncTestClosure = {
              caller.invoke()
            }
            let tearDown: TearDownClosure = {
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
            return {
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
            return {
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
            let test: RunSyncTestClosure = {
              caller.changeValue()
            }
            let tearDown: TearDownClosure = {
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
            let test: RunSyncTestClosure = {
              caller.changeValue()
            }
            let tearDown: TearDownClosure = {
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
}
