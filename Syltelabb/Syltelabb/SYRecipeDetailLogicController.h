//
//  SYTableViewDelegate.h
//  Syltelabb
//
//  Created by Mert Buran on 30/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITableView.h>

@class SYRecipe;

@interface SYRecipeDetailLogicController : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SYRecipe *recipe;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIView *formView;
@property (nonatomic, weak) UIButton *actionButton;
@property (weak, nonatomic, readonly) UITextField *activeTextField;
@property (nonatomic, readonly) BOOL isEditable;
@end
