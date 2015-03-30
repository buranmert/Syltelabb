//
//  SYNetworkManager.h
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@class SYRecipe;

static NSString * const kNetworkUpdateNeededNotificationName = @"networkUpdateNeededNotification";

@interface SYNetworkManager : NSObject

- (AFHTTPRequestOperation *)getRecipesWithSuccess:(void (^)(NSArray *recipesArray))success
                                          failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)deleteRecipeWithId:(NSNumber *)recipeId success:(void (^)())success
                                       failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)updateRecipe:(SYRecipe *)recipe success:(void (^)())success
                                       failure:(void (^)(NSError *error))failure;

@end
