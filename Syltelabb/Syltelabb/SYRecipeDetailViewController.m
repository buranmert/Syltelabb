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
#import "SYTextFieldCell.h"
#import "SYSliderCell.h"
#import "UIView+SYCategory.h"
#import <UIImageView+AFNetworking.h>

static NSString * const kTextFieldCellIdentifier = @"TextFieldCell";
static NSString * const kSliderCellIdentifier    = @"SliderCell";
static NSString * const kNameString              = @"Name";
static NSString * const kDescriptionString       = @"Description";
static NSString * const kInstructionsString      = @"Instructions";
static NSString * const kDifficultyString        = @"Difficulty";
static NSString * const kFavoriteString          = @"Favorite";

@interface SYRecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@end

@implementation SYRecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *imageURLString = [self.recipe url];
    if (imageURLString != nil) {
        NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
        __weak typeof(self) weakSelf = self;
        [self.imageView setImageWithURLRequest:URLRequest
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           CGFloat imageAspectRatio = image.size.height / image.size.width;
                                           [strongSelf.tableView.tableHeaderView setHeight:(imageAspectRatio * CGRectGetWidth(strongSelf.imageView.bounds))];
                                           strongSelf.imageView.image = image;
                                           [strongSelf.imageView layoutIfNeeded];
        }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
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

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return kObligatoryFieldCount;
    }
    else if (section == 1) {
        return self.recipe.nonNilFieldCount - kObligatoryFieldCount;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) { //slider cell
        SYSliderCell *cell = (SYSliderCell *)[tableView dequeueReusableCellWithIdentifier:kSliderCellIdentifier];
        return cell;
    }
    else {//text field cell
        SYTextFieldCell *cell = (SYTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kTextFieldCellIdentifier];
        if (indexPath.section == 0) { //name
            [cell.textField setLeftLabelText:kNameString];
            cell.textField.text = self.recipe.name;
        }
        else if (indexPath.row == 0) {
            [cell.textField setLeftLabelText:kFavoriteString];
            cell.textField.text = self.recipe.name;
        }
        else if (indexPath.row == 1) {
            [cell.textField setLeftLabelText:kDescriptionString];
            cell.textField.text = self.recipe.recipe_description;
        }
        else if (indexPath.row == 2) {
            [cell.textField setLeftLabelText:kInstructionsString];
            cell.textField.text = self.recipe.instructions;
        }
        return cell;
    }
}

#pragma mark - Status bar appearance method

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
