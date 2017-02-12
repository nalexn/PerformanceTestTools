//
//  Promise.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import PromiseKit
import BrightFutures
import Result

// MARK: PromiseKit

class SwiftPromiseKitCaller {
  
  private var fulfill: (() -> Void)?
  
  func givePromise() -> PromiseKit.Promise<Void> {
    return Promise { fulfill, _ in
      self.fulfill = fulfill
    }
  }
  
  func fulfillPromise() {
    fulfill?()
    fulfill = nil
  }
}

// MARK: BrightFutures

typealias TestFuture = BrightFutures.Future<Void, NoError>

class SwiftBrightFuturesCaller {
  
  private var resolver: TestFuture.CompletionCallback?
  
  func provideFuture() -> TestFuture {
    return Future { resolver in
      self.resolver = resolver
    }
  }
  
  func resolve() {
    resolver?(Result(value: ()))
    resolver = nil
  }
}
