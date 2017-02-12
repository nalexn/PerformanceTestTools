//
//  EventTests.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 11/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import XCTest

class SwiftSignalsTests: XCTestCase {
  
  var callee: SwiftSignalsEventCallee!
  var caller: SwiftSignalsEventCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftSignalsEventCallee()
    caller = SwiftSignalsEventCaller()
    callee.observe(event: caller.event)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.triggerEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}

class SwiftEmitterKitTests: XCTestCase {
  
  var callee: SwiftEmitterKitEventCallee!
  var caller: SwiftEmitterKitEventCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftEmitterKitEventCallee()
    caller = SwiftEmitterKitEventCaller()
    callee.observe(event: caller.event)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.triggerEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}
