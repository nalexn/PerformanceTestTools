//
//  ResponderTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftResponderTests: XCTestCase {
  
  var callee: SwiftResponderCallee!
  var caller: SwiftResponderCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftResponderCallee()
    caller = SwiftResponderCaller()
    callee.addSubview(caller)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.triggerResponderChain()
    XCTAssertTrue(callee.wasCalled)
  }
}
