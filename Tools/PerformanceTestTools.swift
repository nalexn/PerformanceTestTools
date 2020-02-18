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

typealias PerformanceTestConstructor = () -> PerformanceTest

typealias TimeUnit = UInt64
typealias PerformanceTestOverhead = (sync: TimeUnit, async: TimeUnit)
typealias PerformanceTestResult = (title: Any, iterations: Int, nanosec: TimeUnit)
typealias PerformanceTestCompletion = (PerformanceTestResult) -> Void

// MARK: PerformanceTestQueue

class PerformanceTestQueue {
  
  private var queue = [PerformanceTestConstructor]()
  private var completion: VoidClosure?
  private var overhead = PerformanceTestOverhead(0, 0)
  private let testCompletion: PerformanceTestCompletion
  
  init(testCompletion: @escaping PerformanceTestCompletion) {
    self.testCompletion = testCompletion
  }
  
  func enqueue(testConstructor: @escaping PerformanceTestConstructor) -> Self {
    queue.append(testConstructor)
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
    guard let testConstructor = queue.first else {
      handleEndOfQueue()
      return
    }
    let test = testConstructor()
    test.launch {
      let nanosec = test.averageTimeInNanoseconds() - self.correctionForTest(test: test)
      self.testCompletion((test.title, test.iterations, nanosec))
      _ = self.queue.remove(at: 0)
      DispatchQueue.main.async(execute: self.performNextPerformanceTest)
    }
  }
  
  private func correctionForTest(test: PerformanceTest) -> TimeUnit {
    switch test.type {
    case .normal:
      return test.isAsync() ? overhead.async : overhead.sync
    case .overheadMeasurement:
      if test.isAsync() {
        overhead.async = test.averageTimeInNanoseconds()
      } else {
        overhead.sync = test.averageTimeInNanoseconds()
      }
      return 0
    }
  }
  
  private func handleEndOfQueue() {
    completion?()
    self.completion = nil
  }
}

// MARK: PerformanceTest

class PerformanceTest {
  fileprivate let iterations: Int
  fileprivate let title: Any
  fileprivate let type: `Type`
  private var syncTestSetup: SyncTestSetupWithTearDown?
  private var asyncTestSetup: AsyncTestSetupWithTearDown?
  private var timer = Timer()
  private var completion: VoidClosure?
  
  enum `Type` {
    case normal
    case overheadMeasurement
  }
  
  init(title: Any, iterations: Int, type: `Type` = .normal) {
    self.iterations = iterations
    self.title = title
    self.type = type
  }
  
  func setup(syncTestSetup: @escaping SyncTestSetup) -> Self {
    return setup(syncTestSetup: {
      return (test: syncTestSetup(), tearDown: { })
    })
  }
  
  func setup(syncTestSetup: @escaping SyncTestSetupWithTearDown) -> Self {
    self.syncTestSetup = syncTestSetup
    return self
  }
  
  func setup(asyncTestSetup: @escaping AsyncTestSetup) -> Self {
    return setup(asyncTestSetup: {
      return (test: asyncTestSetup(), tearDown: { })
    })
  }
  
  func setup(asyncTestSetup: @escaping AsyncTestSetupWithTearDown) -> Self {
    self.asyncTestSetup = asyncTestSetup
    return self
  }
  
  func launch(completion: VoidClosure?) {
    self.completion = completion
    if let syncTestSetup = syncTestSetup {
      launch(syncTestSetup: syncTestSetup)
    } else if let asyncTestSetup = asyncTestSetup {
      launch(iteration: 0, asyncTestSetup: asyncTestSetup)
    } else {
      fatalError("You should 'setup' test before launching")
    }
  }
  
  func isAsync() -> Bool {
    return asyncTestSetup != nil
  }
  
  func averageTimeInNanoseconds() -> TimeUnit {
    return timer.averageTimeInNanoseconds
  }
  
  private func launch(syncTestSetup: SyncTestSetupWithTearDown) {
    for _ in 0 ..< iterations {
      let (test, tearDown) = syncTestSetup()
      timer.start()
      test()
      timer.stop()
      tearDown()
    }
    if let completion = completion {
      DispatchQueue.main.async(execute: completion)
    }
  }
  
  private func launch(iteration: Int, asyncTestSetup: @escaping AsyncTestSetupWithTearDown) {
    guard iteration < iterations else {
      if let completion = completion {
        DispatchQueue.main.async(execute: completion)
      }
      return
    }
    let (test, tearDown) = asyncTestSetup()
    timer.start()
    test {
      self.timer.stop()
      tearDown()
      DispatchQueue.main.async {
        _ = self.launch(iteration: iteration + 1, asyncTestSetup: asyncTestSetup)
      }
    }
  }
}

// MARK: Timer

fileprivate struct Timer {
  private static var baseInfo: mach_timebase_info = mach_timebase_info(numer: 0, denom: 0)
  private var startTime: TimeUnit = 0
  private var cumulativeTime: TimeUnit = 0
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
  
  var averageTimeInNanoseconds: TimeUnit {
    guard numberOfStarts > 0 else {
      return 0
    }
    return cumulativeTime / UInt64(numberOfStarts) * UInt64(Timer.baseInfo.numer) / UInt64(Timer.baseInfo.denom)
  }
}
