//
//  Tools.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 01/02/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

import Darwin

typealias VoidClosure = () -> Void
typealias SetupClosure = () -> (test: VoidClosure, tearDown: VoidClosure?)

func measurePerformance(_ iterations: Int, setup: SetupClosure) -> Timer {
  var timer = Timer()
  for _ in 0 ..< iterations {
    let (test, tearDown) = setup()
    timer.start()
    test()
    timer.stop()
    tearDown?()
  }
  return timer
}

func print(subject: Any, _ measurements: Timer) {
  let className = String(describing: subject)
  let nanosec = measurements.averageTimeInNanoseconds
  let millisec = TimeInterval(nanosec) / 1_000_000
  print("\(className) average time: \(nanosec)ns (\(millisec)ms)")
}

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

extension Timer {
  func printResults(subject: Any) {
    print(subject: subject, self)
  }
}
