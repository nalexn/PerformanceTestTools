//
//  StreamOfValuesTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 04/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftRxSwiftTests: XCTestCase {
  
  var callee: SwiftRxSwiftCallee!
  var caller: SwiftRxSwiftCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftRxSwiftCallee()
    caller = SwiftRxSwiftCaller()
    callee.observe(stream: caller.stream)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.generateEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}


class SwiftReactiveSwiftTests: XCTestCase {
  
  var callee: SwiftReactiveSwiftCallee!
  var caller: SwiftReactiveSwiftCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftReactiveSwiftCallee()
    caller = SwiftReactiveSwiftCaller()
    callee.observe(stream: caller.stream)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.generateEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}
