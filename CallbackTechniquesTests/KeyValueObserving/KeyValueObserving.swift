//
//  KeyValueObserving.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftKeyValueObservingCallee : NSObject {
  
  var wasCalled = false
  
  func startObserving(object: NSObject) {
    object.addObserver(self, forKeyPath: #keyPath(SwiftKeyValueObservingCaller.value), options: [.new], context: nil)
  }
  
  func stopObserving(object: NSObject) {
    object.removeObserver(self, forKeyPath: #keyPath(SwiftKeyValueObservingCaller.value))
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if #keyPath(SwiftKeyValueObservingCaller.value) == keyPath {
      wasCalled = true
    }
  }
}

class SwiftKeyValueObservingCaller : NSObject {
  
  dynamic var value: CGFloat = 0
  
  func changeValue() {
    value += 1
  }
}
