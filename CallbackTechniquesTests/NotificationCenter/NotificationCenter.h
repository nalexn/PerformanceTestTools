//
//  NotificationCenter.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

FOUNDATION_EXPORT NSString *const TestNotification;

@interface ObjCNotificationCenterCaller : NSObject

- (void)postNotification;

@end

@interface ObjCNotificationCenterCallee : NSObject

@property (nonatomic) BOOL wasCalled;

- (void)subscribe;
- (void)unsubscribe;

@end
