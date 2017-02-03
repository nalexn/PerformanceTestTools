//
//  Delegate.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

protocol SwiftDelegateCallerDelegate {
  func performDelegatedJob()
}

class SwiftDelegateCaller {
  var delegate: SwiftDelegateCallerDelegate?
  
  func callDelegate() {
    delegate?.performDelegatedJob()
  }
}

class SwiftDelegateCallee: SwiftDelegateCallerDelegate {
  
  var wasCalled = false
  
  func performDelegatedJob() {
    wasCalled = true
  }
}
