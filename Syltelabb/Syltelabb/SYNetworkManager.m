//
//  SYNetworkManager.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYNetworkManager.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

static NSString * const kBaseURL = @"http://hyper-recipes.herokuapp.com/";
static NSString * const kRetrieveRelativeURL = @"recipes";

@interface SYNetworkManager ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *networkManager;
@end

@implementation SYNetworkManager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSURL *baseURL = [NSURL URLWithString:kBaseURL];
        self.networkManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (AFHTTPRequestOperation *)getRecipesWithSuccess:(void (^)(NSArray *recipesArray))success
                                          failure:(void (^)(NSError *error))failure {
    return [self.networkManager GET:[SYNetworkManager getURLWithRelativePath:kRetrieveRelativeURL]
                         parameters:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSArray *responseArray = responseObject;
                                success(responseArray);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+ (NSString *)getURLWithRelativePath:(NSString *)relativePath {
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", kBaseURL, relativePath];
    return URLString;
}

@end
