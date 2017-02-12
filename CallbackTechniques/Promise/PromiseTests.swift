//
//  PromiseTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftPromiseKitTests: XCTestCase {
  
  var caller: SwiftPromiseKitCaller!
  
  override func setUp() {
    super.setUp()
    caller = SwiftPromiseKitCaller()
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
}

class SwiftBrightFuturesTests: XCTestCase {
  
  var caller: SwiftBrightFuturesCaller!
  
  override func setUp() {
    super.setUp()
    caller = SwiftBrightFuturesCaller()
  }
  
  func testConnectivity() {
    
    let promiseExpectation = expectation(description: "Future")
    _ = caller.provideFuture().andThen { _ in
      promiseExpectation.fulfill()
    }
    caller.resolve()
    waitForExpectations(timeout: 0.1) { (error) in
      if let error = error {
        XCTFail(error.localizedDescription)
      }
    }
  }
}
