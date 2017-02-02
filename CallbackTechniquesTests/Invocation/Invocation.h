//
//  Invocation.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

@interface ObjCInvocationCaller : NSObject

- (void)setTarget:(id)target selector:(SEL)selector;
- (void)removeTarget;
- (void)invoke;

@end

@interface ObjCInvocationCallee : NSObject

@property (nonatomic) BOOL wasCalled;

- (void)addToCaller:(ObjCInvocationCaller *)caller;
- (void)removeFromCaller:(ObjCInvocationCaller *)caller;

@end
