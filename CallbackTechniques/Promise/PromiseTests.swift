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
}
