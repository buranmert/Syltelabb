//
//  SYNetworkManager.h
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYNetworkManager : NSObject

- (void)getRecipesWithSuccess:(void (^)(NSArray *recipesArray))success
                      failure:(void (^)(NSError *error))failure;

@end
