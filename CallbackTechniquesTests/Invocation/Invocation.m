//
//  Invocation.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Invocation.h"

@interface ObjCInvocationCaller ()

@property (nonatomic, strong) NSInvocation *invocation;

@end

@implementation ObjCInvocationCaller

- (void)setTarget:(id)target selector:(SEL)selector
{
  self.invocation = [self invocationForTarget:target selector:selector];
}

- (NSInvocation *)invocationForTarget:(id)target selector:(SEL)selector
{
  NSMethodSignature *signature = [target methodSignatureForSelector:selector];
  if (signature == nil) return nil;
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  invocation.target = target;
  invocation.selector = selector;
  return invocation;
}

- (void)removeTarget
{
  self.invocation = nil;
}

- (void)invoke
{
  [self.invocation invoke];
}

@end

@implementation ObjCInvocationCallee

- (void)invocationHandler
{
  self.wasCalled = YES;
}

@end
