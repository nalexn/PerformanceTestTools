//
//  KeyValueObserving.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

@interface ObjCKeyValueObservingCaller : NSObject

@property (nonatomic) CGFloat value;

- (void)changeValue;

@end

@interface ObjCKeyValueObservingCallee : NSObject

@property (nonatomic) BOOL wasCalled;

- (void)startObservingObject:(id)object;
- (void)stopObservingObject:(id)object;

@end
