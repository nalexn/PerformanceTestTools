//
//  Delegate.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

@protocol ObjCDelegateCallerDelegate <NSObject>

- (void)performDelegatedJob;

@end

@interface ObjCDelegateCaller : NSObject

@property (nonatomic, weak) id<ObjCDelegateCallerDelegate> delegate;

- (void)callDelegate;

@end

@interface ObjCDelegateCallee : NSObject <ObjCDelegateCallerDelegate>

@property (nonatomic) BOOL wasCalled;

@end
