//
//  PerformanceTestTools.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import Darwin

typealias VoidClosure = () -> Void
typealias RunSyncTestClosure = VoidClosure
typealias RunAsyncTestClosure = (_ completion: @escaping VoidClosure) -> Void
typealias TearDownClosure = VoidClosure

typealias SyncTestSetup = () -> RunSyncTestClosure
typealias SyncTestSetupWithTearDown = () -> (test: RunSyncTestClosure, tearDown: TearDownClosure)
typealias AsyncTestSetup = () -> RunAsyncTestClosure
typealias AsyncTestSetupWithTearDown = () -> (test: RunAsyncTestClosure, tearDown: TearDownClosure)

typealias PerformanceTestConstructor = (_ iterations: Int) -> PerformanceTest

// MARK: PerformanceTestQueue

class PerformanceTestQueue {
  
  private let iterations: Int
  private var queue = [PerformanceTestConstructor]()
  private var completion: VoidClosure?
  
  init(iterations: Int) {
    self.iterations = iterations
  }
  
  func enqueue(constructor: @escaping PerformanceTestConstructor) -> Self {
    queue.append(constructor)
    if queue.count == 1 {
      performNextPerformanceTest()
    }
    return self
  }
  
  func finally(completion: @escaping VoidClosure) {
    self.completion = completion
    DispatchQueue.main.async {
      if self.queue.count == 0 {
        self.handleEndOfQueue()
      }
    }
  }
  
  private func performNextPerformanceTest() {
    guard let constructor = queue.first else {
      handleEndOfQueue()
      return
    }
    let test = constructor(self.iterations)
    test.completion = { _ in
      test.printResults()
      _ = self.queue.remove(at: 0)
      DispatchQueue.main.async(execute: self.performNextPerformanceTest)
    }
  }
  
  private func handleEndOfQueue() {
    completion?()
    self.completion = nil
  }
}

// MARK: PerformanceTest

class PerformanceTest {
  private let iterations: Int
  private let subject: Any
  private var timer = Timer()
  private var didFinish = false
  fileprivate var completion: VoidClosure? {
    didSet {
      if didFinish, let completion = completion {
        DispatchQueue.main.async(execute: completion)
      }
    }
  }
  
  init(subject: Any, iterations: Int) {
    self.iterations = iterations
    self.subject = subject
  }
  
  func launch(testSetup: SyncTestSetup) -> Self {
    return launch(testSetup: { _ in
      return (test: testSetup(), tearDown: { _ in })
    })
  }
  
  func launch(testSetup: SyncTestSetupWithTearDown) -> Self {
    for _ in 0 ..< iterations {
      let (test, tearDown) = testSetup()
      timer.start()
      test()
      timer.stop()
      tearDown()
    }
    didFinish = true
    if let completion = completion {
      DispatchQueue.main.async(execute: completion)
    }
    return self
  }
  
  func launch(testSetup: @escaping AsyncTestSetup) -> Self {
    return launch(testSetup: { _ in
      return (test: testSetup(), tearDown: { _ in })
    })
  }
  
  func launch(testSetup: @escaping AsyncTestSetupWithTearDown) -> Self {
    return launch(iteration: 0, testSetup: testSetup)
  }
  
  private func launch(iteration: Int, testSetup: @escaping AsyncTestSetupWithTearDown) -> Self {
    guard iteration < iterations else {
      didFinish = true
      completion?()
      return self
    }
    let (test, tearDown) = testSetup()
    timer.start()
    test {
      self.timer.stop()
      tearDown()
      DispatchQueue.main.async {
        _ = self.launch(iteration: iteration + 1, testSetup: testSetup)
      }
    }
    return self
  }
  
  func printResults() {
    let nanosec = timer.averageTimeInNanoseconds
    let millisec = TimeInterval(nanosec) / 1_000_000
    print("\(subject) average time: \(nanosec)ns (\(millisec)ms)")
  }
}

// MARK: Timer

fileprivate struct Timer {
  private static var baseInfo: mach_timebase_info = mach_timebase_info(numer: 0, denom: 0)
  private var startTime: UInt64 = 0
  private var cumulativeTime: UInt64 = 0
  private var numberOfStarts: Int = 0
  
  init() {
    mach_timebase_info(&Timer.baseInfo)
  }
  
  mutating func start() {
    numberOfStarts += 1
    startTime = mach_absolute_time()
  }
  
  mutating func stop() {
    cumulativeTime += mach_absolute_time() - startTime
  }
  
  var averageTimeInNanoseconds: UInt64 {
    return cumulativeTime / UInt64(numberOfStarts) * UInt64(Timer.baseInfo.numer) / UInt64(Timer.baseInfo.denom)
  }
}
