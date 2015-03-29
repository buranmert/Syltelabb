//
//  UIView+SYCategory.m
//  Syltelabb
//
//  Created by Mert Buran on 29/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "UIView+SYCategory.h"

@implementation UIView (SYCategory)

- (void)addCenteredSubview:(UIView *)subview {
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:subview];
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f];
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f];
    [self addConstraints:@[constraintX, constraintY]];
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}

@end
