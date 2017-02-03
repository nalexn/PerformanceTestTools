//
//  ReactiveSignal.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 04/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import ReactiveSwift
import Result

typealias TestSignal = Signal<Void, NoError>

class SwiftReactiveSignalCaller {
  
  private var observer: Observer<Void, NoError>!
  var signal: TestSignal!
  
  init() {
    signal = TestSignal { observer in
      self.observer = observer
      return nil
    }
  }
  
  func generateEvent() {
    observer.send(value: ())
  }
}

class SwiftReactiveSignalCallee {
  
  var wasCalled = false
  
  func observe(signal: TestSignal) {
    signal.observeValues { [weak self] _ in
      self?.wasCalled = true
    }
  }
}
