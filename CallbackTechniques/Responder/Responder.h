//
//  Responder.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 30/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

@interface ObjCResponderCaller : UIControl

- (void)triggerResponderChain;

@end

@interface ObjCResponderCallee : UIView

@property (nonatomic) BOOL wasCalled;

@end
