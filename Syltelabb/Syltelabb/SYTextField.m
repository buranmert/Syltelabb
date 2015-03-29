//
//  SYTextField.m
//  Syltelabb
//
//  Created by Mert Buran on 29/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYTextField.h"

static const CGFloat kTextFieldFontSize = 14.f;

@implementation SYTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    //all textfields in the app should look similar
    self.tintColor = [UIColor redColor];
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:kTextFieldFontSize];
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentRight;
}

- (void)setLeftLabelText:(NSString *)leftLabelString {
    if (self.leftView == nil) {
        UILabel *leftLabel = [UILabel new];
        [leftLabel setFont:self.font];
        [leftLabel setTextColor:self.textColor];
        [leftLabel setText:leftLabelString];
        [leftLabel sizeToFit];
        [self setLeftView:leftLabel];
        [self setLeftViewMode:UITextFieldViewModeAlways];
    }
    else {
        UILabel *leftLabel;
        for (UIView *subview in self.leftView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                leftLabel = (UILabel *)subview;
                break;
            }
        }
        leftLabel.text = leftLabelString;
    }
}

@end
