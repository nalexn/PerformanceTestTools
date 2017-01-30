//
//  KeyValueObserving.m
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

#import "KeyValueObserving.h"

@implementation ObjCKeyValueObservingCaller

- (void)changeValue
{
  self.value += 1.;
}

@end

#define ObservedKeyPath   @"value"

@implementation ObjCKeyValueObservingCallee

- (void)startObservingObject:(id)object
{
  [object addObserver:self forKeyPath:ObservedKeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)stopObservingObject:(id)object
{
  [object removeObserver:self forKeyPath:ObservedKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
  if ([keyPath isEqualToString:ObservedKeyPath]) {
    self.wasCalled = YES;
  }
}

@end
