//
//  Closure.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

typealias TestClosure = () -> Void

class SwiftClosureCaller {
  var closure: TestClosure?
  
  func performClosure() {
    closure?()
  }
}

class SwiftClosureCallee {
  
  var wasCalled = false
  
  func callback() -> TestClosure {
    return { [weak self] _ in
      self?.wasCalled = true
    }
  }
}
