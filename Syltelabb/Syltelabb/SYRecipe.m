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

- (BOOL)isDifferentFrom:(SYRecipe *)aRecipe {
    if (![self.name isEqualToString:aRecipe.name]) {
        return YES;
    }
    else if (![self.description isEqualToString:aRecipe.description]) {
        return YES;
    }
    else if (![self.instructions isEqualToString:aRecipe.instructions]) {
        return YES;
    }
    else if (self.favorite.boolValue != aRecipe.favorite.boolValue) {
        return YES;
    }
    else if (self.difficulty.integerValue != aRecipe.difficulty.integerValue) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)serialize {
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    if (self.name != nil) {
        [temp setObject:self.name forKey:@"name"];
    }
    if (self.recipe_description != nil) {
        [temp setObject:self.recipe_description forKey:@"description"];
    }
    if (self.instructions != nil) {
        [temp setObject:self.instructions forKey:@"instructions"];
    }
    if (self.difficulty != nil) {
        [temp setObject:self.difficulty forKey:@"difficulty"];
    }
    if (self.favorite != nil) {
        [temp setObject:self.favorite forKey:@"favorite"];
    }
    return [NSDictionary dictionaryWithObject:temp forKey:@"recipe"];
}

@end
