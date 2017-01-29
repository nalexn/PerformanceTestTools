//
//  NotificationCenter.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "NotificationCenter.h"

NSString *const TestNotification = @"test_notification";

@implementation ObjCNotificationCenterCaller

- (void)postNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:TestNotification object:self];
}

@end

@implementation ObjCNotificationCenterCallee

- (void)subscribe
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TestNotification object:nil];
}

- (void)unsubscribe
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:TestNotification object:nil];
}

- (void)handleNotification:(NSNotification *)notification
{
  self.wasCalled = YES;
}

@end
