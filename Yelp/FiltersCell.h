//
//  FiltersCell.h
//  Yelp
//
//  Created by Chad Jewsbury on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersCell;

@protocol FiltersCellDelegate <NSObject>

- (void)filtersCell:(FiltersCell *)filtersCell valueDidChange:(BOOL)value;

@end

@interface FiltersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;
@property (weak, nonatomic) id<FiltersCellDelegate> delegate;

@end
