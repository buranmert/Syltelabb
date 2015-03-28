//
//  SYNavigationControllerDelegate.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYNavigationControllerDelegate.h"
#import "SYTransition.h"

@interface SYNavigationControllerDelegate ()
@property (nonatomic, strong) SYTransition *customTransition;
@end

@implementation SYNavigationControllerDelegate

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _customTransition = [SYTransition new];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self.customTransition;
    }
    else {
        return nil;
    }
}

@end
