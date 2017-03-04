//
//  Task.h
//  PerformanceTests
//
//  Created by Alexey Naumov on 04/03/2017.
//  Copyright © 2017 Alexey Naumov. All rights reserved.
//

@interface ObjCOperationCaller : NSObject

- (NSOperation *)operation;

@end

@interface ObjCOperationCallee : NSObject

@property (nonatomic) BOOL wasCalled;

- (NSOperation *)operationAwaiting:(NSOperation *)operationToWait;

@end
