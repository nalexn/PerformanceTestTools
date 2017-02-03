//
//  ReactiveSignalTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 04/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftReactiveSignalTests: XCTestCase {
  
  var callee: SwiftReactiveSignalCallee!
  var caller: SwiftReactiveSignalCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftReactiveSignalCallee()
    caller = SwiftReactiveSignalCaller()
    callee.observe(signal: caller.signal)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.generateEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}
