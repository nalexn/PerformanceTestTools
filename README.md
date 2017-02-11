# PerformanceTestTools

Benchmarking tool for measuring performance of _sync_ and _async_ code in `Swift` or `Objective-C`.

## Why?

Because built-in `XCTest` performance measurer has very limited functionality.

## Features over `XCTest.measure()`
* async code performance measurements
* ability to assert the maximum acceptable code execution time
* multi-iterational measurements for better accuracy
* export of results in your format

It works with your favorite testing framework and doesn't bring in new dependencies.

## Example maybe?

``` swift
let iterations = 50000

// You define what to do with the results:
let testCompletion = { (title: Any, iterations: Int, nanosec: TimeUnit) in
  print("The average time for \(title) is \(nanosec)ns")
  XCTAssert(nanosec < 1_000_000, "Expected the code to work faster!")
}

// Run tests in the queue:
PerformanceTestQueue(testCompletion: testCompletion)
  // Simple syncronous test
  .enqueue { () -> PerformanceTest in
    return PerformanceTest(title: "Sync Calculator", iterations: iterations)
      .setup { () -> RunSyncTestClosure in
        let sut = Calculator()
        return { _ in
          sut.performSyncComputations()
        }
      }
  }
  // Asyncronous test with tear down
  .enqueue { () -> PerformanceTest in
    return PerformanceTest(title: "Async Calculator", iterations: iterations)
      .setup { () -> RunAsyncTestClosure in
        let sut = Calculator()
        let test: RunAsyncTestClosure = { completion -> Void in
          sut.performAsyncComputations { _ -> Void in
            completion()
          }
        }
        let tearDown: TearDownClosure = { _ in
          sut.cleanUp()
        }
        return (test: test, tearDown: tearDown)
      }
  }
``` 

See more examples in the `CallbacksPerformanceTests.swift` file where I benchmark different types of callbacks available in the `Cocoa` implemented in both `Swift` and `Objective-C`.

## Integration

Just copy the `PerformanceTestTools.swift` file to your test target.

## License

`PerformanceTestTools` is available under the MIT license. See the LICENSE file for more info.