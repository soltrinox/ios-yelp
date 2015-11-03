//
//  FiltersCell.m
//  Yelp
//
//  Created by Chad Jewsbury on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersCell.h"

@interface FiltersCell ()

@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;

@end

@implementation FiltersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onValueChanged:(UISwitch *)sender {
    [self.delegate filtersCell:self valueDidChange:sender.on];
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.filterSwitch setOn:on animated:animated];
}

@end
