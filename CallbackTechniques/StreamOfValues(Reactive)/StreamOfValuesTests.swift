//
//  StreamOfValuesTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 04/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftStreamOfValuesTests: XCTestCase {
  
  var callee: SwiftStreamOfValuesCallee!
  var caller: SwiftStreamOfValuesCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftStreamOfValuesCallee()
    caller = SwiftStreamOfValuesCaller()
    callee.observe(stream: caller.stream)
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.generateEvent()
    XCTAssertTrue(callee.wasCalled)
  }
}
