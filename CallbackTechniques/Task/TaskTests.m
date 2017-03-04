//
//  TaskTests.m
//  PerformanceTests
//
//  Created by Alexey Naumov on 04/03/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Task.h"

@interface TaskTests : XCTestCase

@property (nonatomic, strong) ObjCOperationCallee *callee;
@property (nonatomic, strong) ObjCOperationCaller *caller;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation TaskTests

- (void)setUp {
  [super setUp];
  self.callee = [ObjCOperationCallee new];
  self.caller = [ObjCOperationCaller new];
  self.operationQueue = [NSOperationQueue new];
  self.operationQueue.suspended = YES;
  NSOperation *callerOperation = [self.caller operation];
  NSOperation *calleeOperation = [self.callee operationAwaiting:callerOperation];
  [self.operationQueue addOperation:calleeOperation];
  [self.operationQueue addOperation:callerOperation];
}

- (void)testConnectivity {
  XCTAssertFalse(self.callee.wasCalled);
  self.operationQueue.suspended = NO;
  [self.operationQueue waitUntilAllOperationsAreFinished];
  XCTAssertTrue(self.callee.wasCalled);
}

@end
