//
//  Tools.swift
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

typealias PerformanceTestConstructor = () -> PerformanceTest

// MARK: PerformanceTestQueue

class PerformanceTestQueue {
  
  private var queue = [PerformanceTestConstructor]()
  private var completion: VoidClosure?
  
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
    let test = constructor()
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
  
  func launch(syncTest: @escaping SyncTestSetup) -> Self {
    return launch(syncTest: { _ in
      return (test: syncTest(), tearDown: { _ in })
    })
  }
  
  func launch(syncTest: SyncTestSetupWithTearDown) -> Self {
    for _ in 0 ..< iterations {
      let (test, tearDown) = syncTest()
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
  
  func launch(asyncTest: @escaping AsyncTestSetup) -> Self {
    return launch(asyncTest: { _ in
      return (test: asyncTest(), tearDown: { _ in })
    })
  }
  
  func launch(asyncTest: @escaping AsyncTestSetupWithTearDown) -> Self {
    return launch(iteration: 0, asyncTest: asyncTest)
  }
  
  private func launch(iteration: Int, asyncTest: @escaping AsyncTestSetupWithTearDown) -> Self {
    guard iteration < iterations else {
      didFinish = true
      completion?()
      return self
    }
    let (test, tearDown) = asyncTest()
    timer.start()
    test {
      self.timer.stop()
      tearDown()
      DispatchQueue.main.async {
        _ = self.launch(iteration: iteration + 1, asyncTest: asyncTest)
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

struct Timer {
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
