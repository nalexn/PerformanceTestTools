//
//  Signal.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 11/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import Signals

typealias TestSignal = Signal<Void>

class SwiftSignalCaller {
  let signal = TestSignal()
  
  func fireSignal() {
    signal.fire()
  }
}

class SwiftSignalCallee {
  
  var wasCalled = false
  
  func observe(signal: TestSignal) {
    signal.subscribe(on: self) { [weak self] _ in
      self?.wasCalled = true
    }
  }
}
