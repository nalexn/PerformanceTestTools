//
//  ClosureTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftClosureTests: XCTestCase {
  
  var callee: SwiftClosureCallee!
  var caller: SwiftClosureCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftClosureCallee()
    caller = SwiftClosureCaller()
    caller.closure = callee.callback()
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.performClosure()
    XCTAssertTrue(callee.wasCalled)
  }
  
  func testPerformanceExample() {
    self.measure {
      self.caller.performClosure()
    }
  }
}
