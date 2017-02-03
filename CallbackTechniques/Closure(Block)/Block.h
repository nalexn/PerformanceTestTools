//
//  Block.h
//  CallbackTechniques
//
//  Created by Alexey Naumov on 29/01/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

typedef void (^TestBlock)();

@interface ObjCBlockCaller : NSObject

@property (nonatomic, copy) TestBlock block;

- (void)callBlock;

@end

@interface ObjCBlockCallee : NSObject

@property (nonatomic) BOOL wasCalled;

- (TestBlock)callback;

@end
