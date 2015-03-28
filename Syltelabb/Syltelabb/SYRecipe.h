//
//  SYRecipe.h
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYRecipe : NSObject
@property (nonatomic, strong) NSNumber *recipe_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *recipe_description;
@property (nonatomic, strong) NSString *instructions;
@property (nonatomic, strong) NSNumber *favorite;
@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *thumbnail_url;

+ (instancetype)recipeWithDictionary:(NSDictionary *)dictionary;
@end
