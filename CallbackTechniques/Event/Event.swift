//
//  Event.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 11/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import Signals

typealias TestEvent = Signal<Void>

class SwiftEventCaller {
  let Event = TestEvent()
  
  func triggerEvent() {
    Event.fire()
  }
}

class SwiftEventCallee {
  
  var wasCalled = false
  
  func observe(Event: TestEvent) {
    Event.subscribe(on: self) { [weak self] _ in
      self?.wasCalled = true
    }
  }
}
