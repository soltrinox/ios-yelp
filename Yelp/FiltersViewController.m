//
//  FiltersViewController.m
//  Yelp
//
//  Created by Chad Jewsbury on 10/29/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Filters";
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                  target:self
                                                                                  action:@selector(searchButtonTapped)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)searchButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
