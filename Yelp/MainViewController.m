//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *businesses;
- (void) fetchBusinessesWithQuery:(NSString *)query params:(NSArray *)params;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Yelp";

    [self setupNavigationBar];
    [self setupTableView];
    [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
}

#pragma mark - Setup Methods

- (void)setupNavigationBar {
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onFiltersTapped)];
    self.navigationItem.leftBarButtonItem = filtersButton;
    self.navigationItem.titleView = [[UISearchBar alloc] init];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

#pragma mark - API Methods

- (void) fetchBusinessesWithQuery:(NSString *)query params:(NSArray *)params {
    [YelpBusiness searchWithTerm:query
                        sortMode:YelpSortModeBestMatched
                      categories:params
                           deals:YES
                      completion:^(NSArray *businesses, NSError *error) {
                          self.businesses = businesses;
                          [self.tableView reloadData];
                      }];
}

#pragma mark - Events Methods

- (void)onFiltersTapped {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
