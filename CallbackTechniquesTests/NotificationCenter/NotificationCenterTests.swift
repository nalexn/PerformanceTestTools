//
//  NotificationCenterTests.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftNotificationCenterTests: XCTestCase {
  
  var callee: SwiftNotificationCenterCallee!
  var caller: SwiftNotificationCenterCaller!
  
  override func setUp() {
    super.setUp()
    callee = SwiftNotificationCenterCallee()
    caller = SwiftNotificationCenterCaller()
    callee.subscribe()
  }
  
  override func tearDown() {
    callee.unsubscribe()
    super.tearDown()
  }
  
  func testConnectivity() {
    XCTAssertFalse(callee.wasCalled)
    caller.postNotification()
    XCTAssertTrue(callee.wasCalled)
  }
  
  func testPerformanceExample() {
    self.measure {
      _repeat(million_times, { _ in self.caller.postNotification() })
    }
  }
}
