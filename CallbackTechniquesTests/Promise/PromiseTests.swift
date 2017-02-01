//
//  PromiseTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftPromiseTests: XCTestCase {
  
  var caller: SwiftPromiseCaller!
  
  override func setUp() {
    super.setUp()
    caller = SwiftPromiseCaller()
  }
  
  func testConnectivity() {
    
    let promiseExpectation = expectation(description: "Promise")
    _ = caller.givePromise().then { () -> Void in
      promiseExpectation.fulfill()
    }
    caller.fulfillPromise()
    waitForExpectations(timeout: 0.1) { (error) in
      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }
  
  func testPerformanceExample() {
    
    let testExpectation = expectation(description: "for loop completion")
    let promise = caller.givePromise()
    var startTime = TimeInterval(0)
    _ = promise.then { () -> Void in
      let elapsedTime = CACurrentMediaTime() - startTime
      self.measure {
        Thread.sleep(forTimeInterval: elapsedTime)
      }
      testExpectation.fulfill()
    }
    startTime = CACurrentMediaTime()
    caller.fulfillPromise()
    waitForExpectations(timeout: 1.0) { (error) in
      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }
}
