//
//  NotificationCenterTests.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "NotificationCenter.h"

@interface ObjCNotificationCenterTests : XCTestCase

@property (nonatomic, strong) ObjCNotificationCenterCallee *callee;
@property (nonatomic, strong) ObjCNotificationCenterCaller *caller;

@end

@implementation ObjCNotificationCenterTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCNotificationCenterCallee new];
  self.caller = [ObjCNotificationCenterCaller new];
  [self.callee subscribe];
}

- (void)tearDown {
  [self.callee unsubscribe];
  [super tearDown];
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  [self.caller postNotification];
  XCTAssertTrue(self.callee.wasCalled);
}

@end
