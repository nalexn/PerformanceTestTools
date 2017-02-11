//
//  EventTests.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 11/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import XCTest

class SwiftEventTests: XCTestCase {
  
  var callee: SwiftEventCallee!
  var caller: SwiftEventCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftEventCallee()
    caller = SwiftEventCaller()
    callee.observe(Event: caller.Event)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.triggerEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}
