//
//  Task.swift
//  PerformanceTests
//
//  Created by Alexey Naumov on 04/03/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftOperationCaller {
  
  func operation() -> Operation {
    return BlockOperation(block: { })
  }
  
}

class SwiftOperationCallee {
  
  var wasCalled = false
  
  func operation(awaiting operationToWait: Operation) -> Operation {
    let operation = BlockOperation(block: { [weak self] _ in
      self?.wasCalled = true
    })
    operation.addDependency(operationToWait)
    return operation
  }
  
}
