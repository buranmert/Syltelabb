//
//  SYTableViewDelegate.m
//  Syltelabb
//
//  Created by Mert Buran on 30/03/15.
//  Copyright (c) 2015 Mert Buran. All rights reserved.
//

#import "SYRecipeDetailLogicController.h"
#import "SYSliderCell.h"
#import "SYTextFieldCell.h"
#import "SYRecipe.h"

static NSString * const kTextFieldCellIdentifier = @"TextFieldCell";
static NSString * const kSliderCellIdentifier    = @"SliderCell";

static NSString * const kNameString              = @"Name";
static NSString * const kDescriptionString       = @"Description";
static NSString * const kInstructionsString      = @"Instructions";
static NSString * const kDifficultyString        = @"Difficulty";
static NSString * const kFavoriteString          = @"Favorite";

typedef NS_ENUM(NSInteger, SYRecipeFieldType) {
    SYNameTag = 1,
    SYDescriptionTag,
    SYInstructionsTag,
    SYDifficultyTag,
    SYFavoriteTag,
};

@interface SYRecipeDetailLogicController () <UITextFieldDelegate>
@end

@implementation SYRecipeDetailLogicController

#pragma mark - TableView methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Obligatory Fields";
    }
    else { //section == 1
        return @"Optional Fields";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return kObligatoryFieldCount;
    }
    else if (section == 1) {
        return kTotalFieldCount - kObligatoryFieldCount;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) { //slider cell
        SYSliderCell *cell = (SYSliderCell *)[tableView dequeueReusableCellWithIdentifier:kSliderCellIdentifier];
        [cell.difficultyStepper setValue:self.recipe.difficulty.doubleValue];
        [cell.favoriteSlider setOn:self.recipe.favorite.boolValue animated:NO];
        cell.favoriteLabel.textColor = cell.favoriteSlider.isOn ? [UIColor greenColor] : [UIColor whiteColor];
        cell.valueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.recipe.difficulty.integerValue];
        return cell;
    }
    else {//text field cell
        SYTextFieldCell *cell = (SYTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kTextFieldCellIdentifier];
        cell.textField.delegate = self;
        if (indexPath.section == 0 && indexPath.row == 0) { //name
            cell.textField.tag = SYNameTag;
            [cell.textField setLeftLabelText:kNameString];
            cell.textField.text = self.recipe.name;
        }
        else if (indexPath.row == 0) {
            cell.textField.tag = SYDescriptionTag;
            [cell.textField setLeftLabelText:kDescriptionString];
            cell.textField.text = self.recipe.recipe_description;
        }
        else if (indexPath.row == 1) {
            cell.textField.tag = SYInstructionsTag;
            [cell.textField setLeftLabelText:kInstructionsString];
            cell.textField.text = self.recipe.instructions;
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setEditing:!cell.isEditing animated:NO];
    return NO;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.backgroundView != nil) {
        self.backgroundView.alpha = scrollView.contentOffset.y + scrollView.contentInset.top > 0.f ? 1.f : 0.f;
    }
}

- (void)setActionButtonEditable:(BOOL)isEditable {
    if (self.isEditable != isEditable) {
        if (isEditable) { //turn into edit mode
            [self.actionButton setTitle:@"Update Recipe" forState:UIControlStateNormal];
        }
        else { //turn into delete mode
            [self.actionButton setTitle:@"Delete Recipe" forState:UIControlStateNormal];
        }
        _isEditable = isEditable;
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *currentText = [NSMutableString stringWithString:[textField text]];
    [currentText replaceCharactersInRange:range withString:string];
    [self.actionButton setEnabled:!(textField.tag == SYNameTag && currentText.length <= 0)]; //obligatory field: name field
    [self setActionButtonEditable:YES];
    switch (textField.tag) {
        case SYNameTag: {
            self.recipe.name = currentText;
            break;
        }
        case SYDescriptionTag: {
            self.recipe.recipe_description = currentText;
            break;
        }
        case SYInstructionsTag: {
            self.recipe.instructions = currentText;
            break;
        }
        default:
            break;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.formView != nil) {
        NSInteger currentTag = textField.tag;
        currentTag++;
        UITextField *nextTextField = (UITextField *)[self.formView viewWithTag:currentTag];
        if (nextTextField != nil && [nextTextField canBecomeFirstResponder]) {
            [nextTextField becomeFirstResponder];
        }
    }
    return YES;
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    [self setActionButtonEditable:YES];
    self.recipe.difficulty = @((NSInteger)sender.value);
}

- (IBAction)sliderChanged:(UISwitch *)sender {
    [self setActionButtonEditable:YES];
    self.recipe.favorite = @(sender.isOn);
}

@end
