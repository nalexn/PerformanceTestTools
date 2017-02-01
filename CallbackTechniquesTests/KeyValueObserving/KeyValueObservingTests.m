//
//  KeyValueObservingTests.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "KeyValueObserving.h"

@interface ObjCKeyValueObservingTests : XCTestCase

@property (nonatomic, strong) ObjCKeyValueObservingCallee *callee;
@property (nonatomic, strong) ObjCKeyValueObservingCaller *caller;

@end

@implementation ObjCKeyValueObservingTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCKeyValueObservingCallee new];
  self.caller = [ObjCKeyValueObservingCaller new];
  [self.callee startObservingObject:self.caller];
}

- (void)tearDown {
  [self.callee stopObservingObject:self.caller];
  [super tearDown];
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  [self.caller changeValue];
  XCTAssertTrue(self.callee.wasCalled);
}

- (void)testPerformance {
  [self measureBlock:^{
    repeat(number_of_iterations, [self.caller changeValue]);
  }];
}

@end
