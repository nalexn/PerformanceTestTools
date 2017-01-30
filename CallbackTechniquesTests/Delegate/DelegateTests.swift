//
//  DelegateTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftDelegateTests: XCTestCase {
  
  var callee: SwiftDelegateCallee!
  var caller: SwiftDelegateCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftDelegateCallee()
    caller = SwiftDelegateCaller()
    caller.delegate = callee
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.callDelegate()
    XCTAssertTrue(callee.wasCalled)
  }
  
  func testPerformance() {
    self.measure {
      _repeat(million_times, { _ in self.caller.callDelegate() })
    }
  }
}
