//
//  Delegate.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Delegate.h"

@implementation ObjCDelegateCaller

- (void)callDelegate
{
  [self.delegate performDelegatedJob];
}

@end

@implementation ObjCDelegateCallee

- (void)performDelegatedJob
{
  self.wasCalled = YES;
}

@end
