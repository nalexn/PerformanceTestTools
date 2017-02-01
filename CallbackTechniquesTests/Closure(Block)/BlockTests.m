//
//  BlockTests.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Block.h"

@interface ObjCBlockTests : XCTestCase

@property (nonatomic, strong) ObjCBlockCallee *callee;
@property (nonatomic, strong) ObjCBlockCaller *caller;

@end

@implementation ObjCBlockTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCBlockCallee new];
  self.caller = [ObjCBlockCaller new];
  self.caller.block = self.callee.callback;
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  [self.caller callBlock];
  XCTAssertTrue(self.callee.wasCalled);
}

- (void)testPerformance {
  [self measureBlock:^{
    repeat(number_of_iterations, [self.caller callBlock]);
  }];
}

@end
