//
//  SignalTests.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 11/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import XCTest

class SwiftSignalTests: XCTestCase {
  
  var callee: SwiftSignalCallee!
  var caller: SwiftSignalCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftSignalCallee()
    caller = SwiftSignalCaller()
    callee.observe(signal: caller.signal)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.fireSignal()
    XCTAssertTrue(callee.wasCalled)
  }
}
