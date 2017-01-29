//
//  DelegateTests.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Delegate.h"

@interface ObjCDelegateTests : XCTestCase

@property (nonatomic, strong) ObjCDelegateCallee *callee;
@property (nonatomic, strong) ObjCDelegateCaller *caller;

@end

@implementation ObjCDelegateTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCDelegateCallee new];
  self.caller = [ObjCDelegateCaller new];
  self.caller.delegate = self.callee;
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  [self.caller callDelegate];
  XCTAssertTrue(self.callee.wasCalled);
}

- (void)testPerformance {
  [self measureBlock:^{
    [self.caller callDelegate];
  }];
}

@end
