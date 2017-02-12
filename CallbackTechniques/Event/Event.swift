//
//  Event.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 11/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import Signals
import EmitterKit

// MARK: Signals

typealias TestSignalsEvent = Signals.Signal<Void>

class SwiftSignalsEventCaller {
  let event = TestSignalsEvent()
  
  func triggerEvent() {
    event.fire()
  }
}

class SwiftSignalsEventCallee {
  
  var wasCalled = false
  
  func observe(event: TestSignalsEvent) {
    event.subscribe(on: self) { [weak self] _ in
      self?.wasCalled = true
    }
  }
}

// MARK: EmitterKit

typealias TestEmitterKitEvent = EmitterKit.Event<Void>

class SwiftEmitterKitEventCaller {
  let event = TestEmitterKitEvent()
  
  func triggerEvent() {
    event.emit()
  }
}

class SwiftEmitterKitEventCallee {
  
  private var listener: EmitterKit.EventListener<Void>!
  var wasCalled = false
  
  func observe(event: TestEmitterKitEvent) {
    listener = event.on { [weak self] i in
      self?.wasCalled = true
    }
  }
}
