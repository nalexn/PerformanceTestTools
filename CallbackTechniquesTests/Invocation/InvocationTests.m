//
//  InvocationTests.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Invocation.h"

@interface ObjCInvocationTests : XCTestCase

@property (nonatomic, strong) ObjCInvocationCallee *callee;
@property (nonatomic, strong) ObjCInvocationCaller *caller;

@end

@implementation ObjCInvocationTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCInvocationCallee new];
  self.caller = [ObjCInvocationCaller new];
  [self.caller setTarget:self.callee selector:@selector(invocationHandler)];
}

- (void)tearDown
{
  [self.caller removeTarget];
  [super tearDown];
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  [self.caller invoke];
  XCTAssertTrue(self.callee.wasCalled);
}

@end
