//
//  BusinessCell.h
//  Yelp
//
//  Created by Chad Jewsbury on 10/28/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpBusiness.h"

@interface BusinessCell : UITableViewCell

@property (strong, nonatomic) YelpBusiness *business;

@end
