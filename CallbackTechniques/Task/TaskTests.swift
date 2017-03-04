//
//  TaskTests.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 04/03/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftOperationTests: XCTestCase {
  
  var operationQueue: OperationQueue!
  var callee: SwiftOperationCallee!
  var caller: SwiftOperationCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftOperationCallee()
    caller = SwiftOperationCaller()
    operationQueue = OperationQueue()
    operationQueue.isSuspended = true
    let callerOperation = caller.operation()
    let calleeOperation = callee.operation(awaiting: callerOperation)
    operationQueue.addOperation(calleeOperation)
    operationQueue.addOperation(callerOperation)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    operationQueue.isSuspended = false
    operationQueue.waitUntilAllOperationsAreFinished()
    XCTAssertTrue(callee.wasCalled)
  }
  
}
