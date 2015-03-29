//
//  SYNavigationController.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYNavigationController.h"
#import "SYNavigationControllerDelegate.h"

@interface SYNavigationController ()

@end

@implementation SYNavigationController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addPanGestureRecognizer];
}

- (void)addPanGestureRecognizer {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    SYNavigationControllerDelegate *delegate = (SYNavigationControllerDelegate *)self.delegate;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.view];
        if (location.x <  CGRectGetMidX(self.view.bounds) && self.viewControllers.count > 1) { // left half
            delegate.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(self.view.bounds));
        [delegate.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:self.view].x > 0) {
            [delegate.interactionController finishInteractiveTransition];
        } else {
            [delegate.interactionController cancelInteractiveTransition];
        }
        delegate.interactionController = nil;
    }
}

@end
