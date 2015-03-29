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
#import "SYNetworkManager.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <UIImageView+AFNetworking.h>
#import <UIActivityIndicatorView+AFNetworking.h>

static NSString * const kTextFieldCellIdentifier = @"TextFieldCell";
static NSString * const kSliderCellIdentifier    = @"SliderCell";
static NSString * const kNameString              = @"Name";
static NSString * const kDescriptionString       = @"Description";
static NSString * const kInstructionsString      = @"Instructions";
static NSString * const kDifficultyString        = @"Difficulty";
static NSString * const kFavoriteString          = @"Favorite";

@interface SYRecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundBlurView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) SYNetworkManager *networkManager;
@end

@implementation SYRecipeDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *imageURLString = [self.recipe url];
    if (imageURLString != nil) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        __weak typeof(self) weakSelf = self;
        [self.imageView setImageWithURLRequest:imageURLRequest
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           strongSelf.imageView.image = image;
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [strongSelf.tableView setContentInset:UIEdgeInsetsMake(image.size.height, 0.f, 0.f, 0.f)];
                                               strongSelf.backgroundBlurView.alpha = 0.f;
                                           });
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           
                                       }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Obligatory Fields";
    }
    else { //section == 1
        return @"Optional Fields";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return kObligatoryFieldCount;
    }
    else if (section == 1) {
        return kTotalFieldCount - kObligatoryFieldCount;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) { //slider cell
        SYSliderCell *cell = (SYSliderCell *)[tableView dequeueReusableCellWithIdentifier:kSliderCellIdentifier];
        [cell.difficultyStepper setValue:self.recipe.difficulty.doubleValue];
        [cell.favoriteSlider setOn:self.recipe.favorite.boolValue animated:NO];
        cell.favoriteLabel.textColor = cell.favoriteSlider.isOn ? [UIColor greenColor] : [UIColor whiteColor];
        cell.valueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.recipe.difficulty.integerValue];
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setEditing:!cell.isEditing animated:NO];
    return NO;
}

#pragma mark - Scroll view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.backgroundBlurView.alpha = scrollView.contentOffset.y + scrollView.contentInset.top > 0.f ? 1.f : 0.f;
}

#pragma mark - Status bar appearance method

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)actionButtonTapped:(UIButton *)sender {
    if (self.networkManager == nil) {
        self.networkManager = [SYNetworkManager new];
    }
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperation *operation = [self.networkManager deleteRecipeWithId:self.recipe.recipe_id success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }
                                    failure:^(NSError *error) {
                                        
                                    }];
    [self.activityIndicatorView setAnimatingWithStateOfOperation:operation];
}

#warning TODO: KEYBOARD HANDLING

#pragma mark - Keyboard view handling

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"");
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"");
}

@end
