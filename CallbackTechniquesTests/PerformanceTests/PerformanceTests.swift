//
//  PerformanceTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import XCTest

class PerformanceTests: XCTestCase {
  
  func testPerformance() {
    
    let iterations = 1000

    measurePerformance(iterations) { () -> (test: VoidClosure, tearDown: VoidClosure?) in
      let callee = SwiftDelegateCallee()
      let caller = SwiftDelegateCaller()
      caller.delegate = callee
      let test: VoidClosure = { _ in
        caller.callDelegate()
      }
      return (test: test, tearDown: nil)
    }.printResults(subject: "[Swift: Delegate]")

  }
  
}
