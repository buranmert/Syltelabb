//
//  SYRecipe.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYRecipe.h"

@implementation SYRecipe

+ (instancetype)recipeWithDictionary:(NSDictionary *)dictionary {
    SYRecipe *recipe = [SYRecipe new];
    
    for (NSString *key in [dictionary allKeys]) {
        id value = [dictionary objectForKey:key];
        NSString *safeKey;
        if ([key isEqualToString:@"id"] || [key isEqualToString:@"description"]) {
            safeKey = [NSString stringWithFormat:@"recipe_%@", key];
        }
        else {
            safeKey = key;
        }
        
        if (value != [NSNull null]) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                for (NSString *nestedKey in [value allKeys]) {
                    id nestedValue = [value objectForKey:nestedKey];
                    if (nestedValue != [NSNull null]) {
                        [recipe setValue:nestedValue forKey:nestedKey];
                    }
                }
            }
            else {
                [recipe setValue:value forKey:safeKey];
            }
        }
    }
    return recipe;
}

@end
