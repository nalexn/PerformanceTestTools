//
//  Responder.swift
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

class SwiftResponderCallee : UIView {
  
  var wasCalled = false
  
  dynamic func handleAction(sender: AnyObject?) {
    wasCalled = true
  }
}

class SwiftResponderCaller : UIControl {
  
  func triggerResponderChain() {
    self.sendAction(#selector(SwiftResponderCallee.handleAction(sender:)), to: nil, for: nil)
  }
}
