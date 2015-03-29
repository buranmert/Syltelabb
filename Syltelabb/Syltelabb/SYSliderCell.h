//
//  SYSliderCell.h
//  Syltelabb
//
//  Created by Mert Buran on 29/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYSliderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIStepper *difficultyStepper;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSlider;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end
