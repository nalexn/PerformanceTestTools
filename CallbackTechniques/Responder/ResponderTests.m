//
//  ResponderTests.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Responder.h"

@interface ObjCResponderTests : XCTestCase

@property (nonatomic, strong) ObjCResponderCallee *callee;
@property (nonatomic, strong) ObjCResponderCaller *caller;

@end

@implementation ObjCResponderTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCResponderCallee new];
  self.caller = [ObjCResponderCaller new];
  [self.callee addSubview:self.caller];
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  [self.caller triggerResponderChain];
  XCTAssertTrue(self.callee.wasCalled);
}

@end
