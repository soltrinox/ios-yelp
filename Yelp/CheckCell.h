//
//  CheckCell.h
//  Yelp
//
//  Created by Chad Jewsbury on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckCell;

@protocol CheckCellDelegate <NSObject>

- (void)cellWasTapped:(CheckCell *)checkCell;

@end

@interface CheckCell : UITableViewCell

@property (weak, nonatomic) id<CheckCellDelegate> delegate;

@end
