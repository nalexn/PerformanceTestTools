//
//  Task.m
//  PerformanceTests
//
//  Created by Alexey Naumov on 04/03/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Task.h"

@implementation ObjCOperationCaller

- (NSOperation *)operation
{
  return [NSBlockOperation blockOperationWithBlock:^{ }];
}

@end

@implementation ObjCOperationCallee

- (NSOperation *)operationAwaiting:(NSOperation *)operationToWait
{
  __weak typeof(self) weakSelf = self;
  NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    weakSelf.wasCalled = YES;
  }];
  [operation addDependency:operationToWait];
  return operation;
}

@end
