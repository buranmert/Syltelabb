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
#import "SYRecipeDetailLogicController.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <UIImageView+AFNetworking.h>
#import <UIActivityIndicatorView+AFNetworking.h>

@interface SYRecipeDetailViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet SYRecipeDetailLogicController *logicController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundBlurView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) SYNetworkManager *networkManager;
@end

@implementation SYRecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logicController.formView = self.tableView;
    self.logicController.backgroundView = self.backgroundBlurView;
    self.logicController.actionButton = self.actionButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *imageURLString = [self.logicController.recipe url];
    if (imageURLString != nil) {
        [self setBackgroundImageWithURLString:imageURLString];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRecipe:(SYRecipe *)recipe {
    self.logicController.recipe = recipe;
}

- (void)setBackgroundImageWithURLString:(NSString *)imageURLString {
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    __weak typeof(self) weakSelf = self;
    [self.imageView setImageWithURLRequest:imageURLRequest
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       __strong typeof(weakSelf) strongSelf = weakSelf;
                                       strongSelf.imageView.image = image;
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [strongSelf.tableView setContentInset:UIEdgeInsetsMake(CGRectGetHeight(strongSelf.imageView.bounds), 0.f, 0.f, 0.f)];
                                           [strongSelf.tableView setContentOffset:CGPointMake(0.f, -CGRectGetHeight(strongSelf.imageView.bounds)) animated:NO];
                                           strongSelf.backgroundBlurView.alpha = 0.f;
                                       });
                                   }
                                   failure:nil];
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
    AFHTTPRequestOperation *operation;
    if (self.logicController.isEditable) {
        operation = [self.networkManager updateRecipe:self.logicController.recipe
                                              success:^{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                                  });
                                              }
                                              failure:^(NSError *error) {
                                                  
                                              }];
    }
    else {
        operation = [self.networkManager deleteRecipeWithId:self.logicController.recipe.recipe_id success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
                                                    failure:^(NSError *error) {
                                                        
                                                    }];
    }
    [self.activityIndicatorView setAnimatingWithStateOfOperation:operation];
}

#pragma mark - Keyboard view handling

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger keyboardAnimationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect frameToBeVisible = [self.logicController.activeTextField.superview convertRect:self.logicController.activeTextField.frame toView:self.view];
    CGFloat margin = 15.f;
    if (CGRectGetMaxY(frameToBeVisible) >= CGRectGetMinY(keyboardEndFrame) + margin) {
        __block UITableView *tableView = self.tableView;
        self.tableViewBottomSpaceConstraint.constant = CGRectGetHeight(keyboardEndFrame);
        CGFloat difference = CGRectGetMaxY(frameToBeVisible) - CGRectGetMinY(keyboardEndFrame) + margin;
        CGPoint newContentOffset = CGPointMake(0.f, tableView.contentOffset.y + difference);
        [UIView animateWithDuration:keyboardAnimationDuration
                              delay:0.0
                            options:(keyboardAnimationCurve<<16)|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [tableView setContentOffset:newContentOffset animated:NO];
                             [tableView layoutIfNeeded];
                         }
                         completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.tableViewBottomSpaceConstraint.constant > 0.f) {
        NSTimeInterval keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger keyboardAnimationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        self.tableViewBottomSpaceConstraint.constant = 0.f;
        __block UITableView *tableView = self.tableView;
        [UIView animateWithDuration:keyboardAnimationDuration
                              delay:0.0
                            options:(keyboardAnimationCurve<<16)|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [tableView setContentOffset:CGPointMake(0.f, 0.f) animated:NO];
                             [tableView layoutIfNeeded];
                         }
                         completion:nil];
    }
}

@end
