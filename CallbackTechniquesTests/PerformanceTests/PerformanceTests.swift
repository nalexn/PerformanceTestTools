//
//  PerformanceTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import XCTest

class PerformanceTests: XCTestCase {
  
  let iterations = 1000
  
  func testPerformance() {
    measurePerformanceOfDelegate()
    measurePerformanceOfNotificationCenter()
    measurePerformanceOfClosureAndBlock()
    measurePerformanceOfInvocation()
    measurePerformanceOfResponder()
    measurePerformanceOfKeyValueObserving()
  }
  
  // MARK: - Delegate
  
  func measurePerformanceOfDelegate() {
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = SwiftDelegateCallee()
      let caller = SwiftDelegateCaller()
      caller.delegate = callee
      let test: VoidClosure = { _ in
        caller.callDelegate()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Swift: Delegate]")
    
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = ObjCDelegateCallee()
      let caller = ObjCDelegateCaller()
      caller.delegate = callee
      let test: VoidClosure = { _ in
        caller.callDelegate()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Obj-C: Delegate]")
  }
  
  // MARK: - NotificationCenter
  
  func measurePerformanceOfNotificationCenter() {
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
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
    }.printResults(subject: "[Swift: NotificationCenter]")
    
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
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
    }.printResults(subject: "[Obj-C: NotificationCenter]")
  }
  
  // MARK: - Closure/Block
  
  func measurePerformanceOfClosureAndBlock() {
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = SwiftClosureCallee()
      let caller = SwiftClosureCaller()
      caller.closure = callee.callback()
      let test: VoidClosure = { _ in
        caller.performClosure()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Swift: Closure]")
    
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = ObjCBlockCallee()
      let caller = ObjCBlockCaller()
      caller.block = callee.callback()
      let test: VoidClosure = { _ in
        caller.callBlock()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Obj-C: Block]")
  }
  
  // MARK: - Invocation
  
  func measurePerformanceOfInvocation() {
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = ObjCInvocationCallee()
      let caller = ObjCInvocationCaller()
      caller.setTarget(callee, selector: #selector(ObjCInvocationCallee.invocationHandler))
      let test: VoidClosure = { _ in
//        caller.invoke()
      }
      let tearDown: VoidClosure = { _ in
        caller.removeTarget()
      }
      return (test: test, tearDown: tearDown)
    }.printResults(subject: "[Obj-C: Invocation]")
  }
  
  // MARK: - Responder
  
  func measurePerformanceOfResponder() {
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = SwiftResponderCallee()
      let caller = SwiftResponderCaller()
      callee.addSubview(caller)
      let test: VoidClosure = { _ in
        caller.triggerResponderChain()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Swift: Responder]")
    
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = ObjCResponderCallee()
      let caller = ObjCResponderCaller()
      callee.addSubview(caller)
      let test: VoidClosure = { _ in
        caller.triggerResponderChain()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Obj-C: Responder]")
  }
  
  // MARK: - KeyValueObserving
  
  func measurePerformanceOfKeyValueObserving() {
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
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
    }.printResults(subject: "[Swift: KeyValueObserving]")
    
    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
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
    }.printResults(subject: "[Obj-C: KeyValueObserving]")
  }
}
