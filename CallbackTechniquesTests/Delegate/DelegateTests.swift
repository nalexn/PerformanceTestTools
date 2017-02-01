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
  
  func srepeat(iterations: Int, code: @autoclosure () -> Void) {
    for _ in 0 ..< iterations {
      code()
    }
  }
  
  func testPerformance() {
    self.measure {
      for _ in 0 ..< number_of_iterations {
        self.caller.callDelegate()
      }
    }
  }
}
