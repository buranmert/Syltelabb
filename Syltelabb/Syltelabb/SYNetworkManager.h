//
//  SYNetworkManager.h
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface SYNetworkManager : NSObject

- (AFHTTPRequestOperation *)getRecipesWithSuccess:(void (^)(NSArray *recipesArray))success
                                          failure:(void (^)(NSError *error))failure;

@end
