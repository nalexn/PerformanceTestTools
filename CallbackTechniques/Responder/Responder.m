//
//  Responder.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Responder.h"

@implementation ObjCResponderCallee

- (IBAction)handleAction:(id)sender
{
  self.wasCalled = YES;
}

@end

@implementation ObjCResponderCaller

- (void)triggerResponderChain
{
  [self sendAction:@selector(handleAction:) to:nil forEvent:nil];
}

@end
