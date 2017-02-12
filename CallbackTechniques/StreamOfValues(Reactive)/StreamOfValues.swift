//
//  StreamOfValues.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 04/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import RxSwift
import ReactiveSwift
import Result

// MARK: RxSwift

typealias TextRxSwiftStream = RxSwift.Observable<Void>

class SwiftRxSwiftCaller {
  
  private var observer: RxSwift.AnyObserver<Void>!
  var stream: TextRxSwiftStream!
  
  init() {
    stream = TextRxSwiftStream.create { observer in
      self.observer = observer
      return Disposables.create()
    }
  }
  
  func generateEvent() {
    observer.on(.next(()))
  }
}

class SwiftRxSwiftCallee {
  
  var wasCalled = false
  
  func observe(stream: TextRxSwiftStream) {
    _ = stream.subscribe(onNext: { [weak self] _ in
      self?.wasCalled = true
    })
  }
}

// MARK: ReactiveSwift

typealias TestReactiveSwiftStream = ReactiveSwift.Signal<Void, NoError>

class SwiftReactiveSwiftCaller {
  
  private var observer: Observer<Void, NoError>!
  var stream: TestReactiveSwiftStream!
  
  init() {
    stream = TestReactiveSwiftStream { observer in
      self.observer = observer
      return nil
    }
  }
  
  func generateEvent() {
    observer.send(value: ())
  }
}

class SwiftReactiveSwiftCallee {
  
  var wasCalled = false
  
  func observe(stream: TestReactiveSwiftStream) {
    stream.observeValues { [weak self] _ in
      self?.wasCalled = true
    }
  }
}
