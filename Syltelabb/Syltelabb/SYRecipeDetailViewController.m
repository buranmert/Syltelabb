//
//  SYRecipeDetailViewController.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYRecipeDetailViewController.h"
#import "SYNavigationControllerDelegate.h"
#import "SYRecipe.h"
#import <UIImageView+AFNetworking.h>

@interface SYRecipeDetailViewController ()

@end

@implementation SYRecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameLabel setText:self.recipe.name];
    [self.descriptionLabel setText:self.recipe.recipe_description];
    [self.instructionsLabel setText:self.recipe.instructions];
    NSString *imageURLString = [self.recipe url];
    if (imageURLString != nil) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [self.imageView setImageWithURL:imageURL];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)updateButtonTapped:(UIButton *)sender {
    
}

- (IBAction)goBackButtonTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
