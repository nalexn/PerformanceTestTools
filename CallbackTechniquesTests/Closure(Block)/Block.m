//
//  Block.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "Block.h"

@implementation ObjCBlockCaller

- (void)callBlock
{
  if (self.block != NULL) {
    self.block();
  }
}

@end

@implementation ObjCBlockCallee

- (TestBlock)callback
{
  __weak typeof(self) weakSelf = self;
  return ^() {
    weakSelf.wasCalled = YES;
  };
}

@end
