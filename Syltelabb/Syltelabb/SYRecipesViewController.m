//
//  SYRecipesViewController.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYRecipesViewController.h"
#import "SYRecipeDetailViewController.h"
#import "SYNetworkManager.h"
#import "SYRecipe.h"
#import "NSString+SYCategory.h"
#import <UIImageView+AFNetworking.h>
#import <UIActivityIndicatorView+AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

static NSString * const kDetailViewControllerIdentifier = @"RecipeDetailViewController";

@interface SYRecipesViewController ()
@property (nonatomic, strong) SYNetworkManager *networkManager;
@property (nonatomic, strong) NSArray *dataSourceArray;
@end

@implementation SYRecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [NSArray array];
    self.networkManager = [SYNetworkManager new];
    [self fetchRecipes:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchRecipes:) name:kNetworkUpdateNeededNotificationName object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Network operation methods

- (void)fetchRecipes:(NSNotification *)notification {
    BOOL willScrollToTop = notification == nil ? NO : YES;
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperation *operation = [self.networkManager getRecipesWithSuccess:^(NSArray *recipesArray) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSMutableArray *newRecipesArray = [NSMutableArray array];
        for (NSDictionary *recipeDictionary in recipesArray) {
            SYRecipe *recipe = [SYRecipe recipeWithDictionary:recipeDictionary];
            [newRecipesArray addObject:recipe];
        }
        strongSelf.dataSourceArray = [newRecipesArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[(SYRecipe *)obj1 recipe_id] integerValue] > [[(SYRecipe *)obj2 recipe_id] integerValue] ;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reloadCollectionViewScrollToTop:willScrollToTop];
        });
    }
                                                                           failure:^(NSError *error) {
                                                                               //may pop an AlertController
                                                                           }];
    [self.view bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView setAnimatingWithStateOfOperation:operation];
}

#pragma mark - RPSlidingMenuViewController methods

// return the number of menu items
- (NSInteger)numberOfItemsInSlidingMenu {
    return self.dataSourceArray.count;
}

// set properties of the cell like the textLabel.text, detailLabel.text and backgroundImageView.image
- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row {
    SYRecipe *recipe = [self.dataSourceArray objectAtIndex:row];
    
    NSString *name = [recipe name];
    if ([[recipe favorite] boolValue] == YES) {
        name = [NSString stringWithFormat:@"%@%@%@", [NSString shrekHeart], name, [NSString shrekHeart]];
    }
    slidingMenuCell.textLabel.text = name;
    
    NSString *description = [recipe recipe_description];
    slidingMenuCell.detailTextLabel.text = description;
    
    NSString *imageURLString = [recipe thumbnail_url];
    if (imageURLString != nil) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [slidingMenuCell.backgroundImageView setImageWithURL:imageURL];
    }
}

// optionally to handle a menu item being tapped
- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row {
    [super slidingMenu:slidingMenu didSelectItemAtRow:row];
    
    SYRecipe *recipe = [self.dataSourceArray objectAtIndex:row];
    SYRecipeDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:kDetailViewControllerIdentifier];
    [detailVC setRecipe:recipe];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
