//
//  SYRecipeDetailViewController.h
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYBaseViewController.h"

@class SYRecipe;

@interface SYRecipeDetailViewController : SYBaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SYRecipe *recipe;
@end
