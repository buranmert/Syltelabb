//
//  SYBaseViewController.m
//  Syltelabb
//
//  Created by Mert Buran on 28/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYBaseViewController.h"
#import "UIView+SYCategory.h"

@interface SYBaseViewController ()

@end

@implementation SYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicatorView = [self setupActivityIndicatorView];
    [self.view addCenteredSubview:self.activityIndicatorView];
}

- (UIActivityIndicatorView *)setupActivityIndicatorView {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.color = [UIColor greenColor];
    activityIndicatorView.hidesWhenStopped = YES;
    return activityIndicatorView;
}

@end
