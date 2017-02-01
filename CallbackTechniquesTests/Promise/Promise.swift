//
//  Promise.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import PromiseKit

class SwiftPromiseCaller {
  
  private var fulfill: (() -> Void)?
  
  func givePromise() -> Promise<Void> {
    return Promise { fulfill, _ in
      self.fulfill = fulfill
    }
  }
  
  func fulfillPromise() {
    fulfill?()
    fulfill = nil
  }
}
