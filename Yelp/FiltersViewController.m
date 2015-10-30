//
//  FiltersViewController.m
//  Yelp
//
//  Created by Chad Jewsbury on 10/29/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FiltersCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
}

- (void)setupNavigation {
    self.navigationItem.title = @"Filters";
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                        target:self
                                                        action:@selector(searchButtonTapped)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FiltersCell" bundle:nil] forCellReuseIdentifier:@"FiltersCell"];
    self.tableView.rowHeight = 48;
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiltersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FiltersCell"];
    
    return cell;
}

- (void)searchButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
