//
//  KeyValueObservingTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftKeyValueObservingTests: XCTestCase {
  
  var callee: SwiftKeyValueObservingCallee!
  var caller: SwiftKeyValueObservingCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftKeyValueObservingCallee()
    caller = SwiftKeyValueObservingCaller()
    callee.startObserving(object: caller)
  }
  
  override func tearDown() {
    callee.stopObserving(object: caller)
    super.tearDown()
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.changeValue()
    XCTAssertTrue(callee.wasCalled)
  }
}
