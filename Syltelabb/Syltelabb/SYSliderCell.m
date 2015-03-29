//
//  SYSliderCell.m
//  Syltelabb
//
//  Created by Mert Buran on 29/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYSliderCell.h"

@interface SYSliderCell ()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation SYSliderCell

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSUInteger integerValue = (NSUInteger)sender.value;
    NSString *valueString = [NSString stringWithFormat:@"%lul", (unsigned long)integerValue];
    [self.valueLabel setText:valueString];
}

@end
