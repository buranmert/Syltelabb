//
//  SYNavigationControllerDelegate.h
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <UIKit/UINavigationController.h>
#import <UIKit/UIViewControllerTransitioning.h>

@interface SYNavigationControllerDelegate : NSObject <UINavigationControllerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@end
