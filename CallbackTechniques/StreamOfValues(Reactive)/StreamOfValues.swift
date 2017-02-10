//
//  StreamOfValues.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 04/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import ReactiveSwift
import Result

typealias TestStream = Signal<Void, NoError>

class SwiftStreamOfValuesCaller {
  
  private var observer: Observer<Void, NoError>!
  var stream: TestStream!
  
  init() {
    stream = TestStream { observer in
      self.observer = observer
      return nil
    }
  }
  
  func generateEvent() {
    observer.send(value: ())
  }
}

class SwiftStreamOfValuesCallee {
  
  var wasCalled = false
  
  func observe(stream: TestStream) {
    stream.observeValues { [weak self] _ in
      self?.wasCalled = true
    }
  }
}
