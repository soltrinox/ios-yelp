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

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *businesses;
- (void) fetchBusinessesWithQuery:(NSString *)query filters:(NSDictionary *)filters;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Yelp";

    [self setupNavigationBar];
    [self setupTableView];
    [self fetchBusinessesWithQuery:@"Restaurants" filters:nil];
}

#pragma mark - Setup Methods

- (void)setupNavigationBar {
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onFiltersTapped)];
    self.navigationItem.leftBarButtonItem = filtersButton;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
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

- (void) fetchBusinessesWithQuery:(NSString *)query filters:(NSDictionary *)filters {

    NSArray *categories = [filters objectForKey:@"categories"] ? filters[@"categories"] : nil;
    int sortBy = [filters objectForKey:@"sort_by"] ? [filters[@"sort_by"] intValue] : 0;
    float distance = [filters objectForKey:@"distance"] ? [filters[@"distance"] floatValue]: 0;
    BOOL deals = [filters objectForKey:@"show_deals"] ? [filters[@"show_deals"] boolValue]: NO;

    [YelpBusiness searchWithTerm:query
                        sortMode:sortBy
                      categories:categories
                        distance:distance
                           deals:deals
                      completion:^(NSArray *businesses, NSError *error) {
                          self.businesses = businesses;
                          [self.tableView reloadData];
                      }];
}

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {

    NSLog(@"%@", filters);
    [self fetchBusinessesWithQuery:@"restaurants" filters:filters];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"SEARCH: %@", searchText);
    [self fetchBusinessesWithQuery:[searchText stringByAppendingString:@" restaurants"]  filters:nil];
}

#pragma mark - Events Methods

- (void)onFiltersTapped {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
