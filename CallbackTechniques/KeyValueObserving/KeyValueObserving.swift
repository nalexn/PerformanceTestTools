//
//  KeyValueObserving.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import Foundation

class SwiftKeyValueObservingCallee : NSObject {
  
  var wasCalled = false
  private var observation: NSKeyValueObservation?
  
  func startObserving(object: SwiftKeyValueObservingCaller) {
    observation = object.observe(\.value, options: .new) { [weak self] (object, change) in
        self?.wasCalled = true
    }
  }
  
  func stopObserving(object: SwiftKeyValueObservingCaller) {
    observation?.invalidate()
    observation = nil
  }
}

class SwiftKeyValueObservingCaller : NSObject {
  
  @objc dynamic var value: CGFloat = 0
  
  func changeValue() {
    value += 1
  }
}
