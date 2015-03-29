//
//  SYTransition.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYTransition.h"

static const NSTimeInterval kTransitionDuration = 0.5;

@implementation SYTransition

#pragma mark - UIViewControllerContextTransitioning methods

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return kTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (self.operationType == UINavigationControllerOperationPop) {
        toViewController.view.alpha = 0;
        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        fromViewController.view.layer.zPosition = CGFLOAT_MAX;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            CATransform3D scale3D = CATransform3DMakeScale(0.1, 0.1, 0.1);
            CATransform3D rotate3D = CATransform3DMakeRotation(M_PI, 10.f, 10.f, 10.f);
            CATransform3D concat = CATransform3DConcat(scale3D, rotate3D);
            fromViewController.view.layer.transform = concat;
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else { //self.transitionType == SYTransitionPush
        toViewController.view.transform = CGAffineTransformMakeTranslation(0.f, CGRectGetHeight(toViewController.view.bounds));
        toViewController.view.layer.zPosition = CGFLOAT_MAX;
        toViewController.view.alpha = 0.f;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CATransform3D baseTransform = CATransform3DIdentity;
                             baseTransform.m34 = 1.0 / -500;
                             baseTransform = CATransform3DRotate(baseTransform, M_PI_4, 1.f, 0.f, 0.f);
                             fromViewController.view.layer.transform = baseTransform;
                             toViewController.view.transform = CGAffineTransformIdentity;
                             toViewController.view.alpha = 1.f;
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
}

- (void)animationEnded:(BOOL) transitionCompleted {
    //may post a application-wide notification
}

@end
