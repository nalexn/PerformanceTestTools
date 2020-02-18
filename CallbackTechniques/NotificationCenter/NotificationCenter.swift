//
//  NotificationCenter.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

extension NSNotification.Name {
  static let Test = NSNotification.Name(rawValue: "test_notification")
}

class SwiftNotificationCenterCaller {
  func postNotification() {
    NotificationCenter.default.post(name: NSNotification.Name.Test, object: self)
  }
}

class SwiftNotificationCenterCallee {
  
  var wasCalled = false
  
  func subscribe() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: NSNotification.Name.Test, object: nil)
  }
  
  func unsubscribe() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.Test, object: nil)
  }
  
  @objc func handleNotification(notification: Notification) {
    wasCalled = true
  }
}
