//
//  SYSliderCell.m
//  Syltelabb
//
//  Created by Mert Buran on 29/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYSliderCell.h"

@interface SYSliderCell ()
@end

@implementation SYSliderCell

- (void)awakeFromNib {
    [self initialize];
}

- (void)prepareForReuse {
    [self initialize];
}

- (void)initialize {
    [self setAccessoryViewsAlpha:0.f];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    if (state == UITableViewCellStateDefaultMask) {
        [self initialize];
    }
    else if (state == UITableViewCellStateShowingEditControlMask) {
        [self setAccessoryViewsAlpha:1.f];
    }
    else if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        [self initialize];
    }
}

- (void)setAccessoryViewsAlpha:(CGFloat)alpha {
    self.difficultyStepper.alpha = alpha;
    self.favoriteSlider.alpha = alpha;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (IBAction)stepperChanged:(UIStepper *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)sender.value];
}

- (IBAction)sliderChanged:(UISwitch *)sender {
    self.favoriteLabel.textColor = sender.isOn ? [UIColor greenColor] : [UIColor whiteColor];
}

@end
