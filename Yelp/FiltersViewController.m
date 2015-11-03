//
//  FiltersViewController.m
//  Yelp
//
//  Created by Chad Jewsbury on 10/29/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "FiltersCell.h"
#import "CheckCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, FiltersCellDelegate, CheckCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *selectedFilters;
@property (strong, nonatomic) NSMutableArray *allFilters;
@property (strong, nonatomic) NSArray *categories;
@property (nonatomic, readonly) NSDictionary *filters;

- (void)initCategories;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        [self initCategories];
        [self initAllFilters];
    }

    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self initSelectedFilters];
    [self setupNavigation];
}

#pragma mark - Setup methods

- (void)setupNavigation {
    self.navigationItem.title = @"Filters";
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];

    self.navigationItem.rightBarButtonItem = applyButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FiltersCell" bundle:nil] forCellReuseIdentifier:@"filtersCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckCell" bundle:nil] forCellReuseIdentifier:@"checkCell"];
    self.tableView.rowHeight = 48;
    self.selectedFilters = [NSMutableArray array];
    [self.tableView reloadData];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allFilters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *allFilters = self.allFilters[section][@"filters"];
    return allFilters.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.allFilters objectAtIndex:section][@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionTypes = @[@"filtersCell", @"checkCell", @"checkCell", @"filtersCell"];
    FiltersCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionTypes[indexPath.section]];

    cell.delegate = self;

    NSDictionary *row = self.allFilters[indexPath.section][@"filters"][indexPath.row];
    cell.filterLabel.text = row[@"name"];
    cell.on = [self.selectedFilters[indexPath.section][@"filters"] containsObject:self.allFilters[indexPath.section][@"filters"][indexPath.row]];

    return cell;
}

#pragma mark - Switch cell delegate methods

- (void)filtersCell:(FiltersCell *)filtersCell valueDidChange:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:filtersCell];
    if (value) {
        [self.selectedFilters[indexPath.section][@"filters"] addObject:self.allFilters[indexPath.section][@"filters"][indexPath.row]];
    } else {
        [self.selectedFilters[indexPath.section][@"filters"] removeObject:self.allFilters[indexPath.section][@"filters"][indexPath.row]];
    }
}

#pragma mark - Check cell delegate methods

- (void)cellWasTapped:(CheckCell *)checkCell {
    NSLog(@"CheckCell Was Tapped");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:checkCell];

    NSMutableDictionary *section = [self.allFilters objectAtIndex:indexPath.section];
    NSMutableDictionary *row = [section[@"filters"] objectAtIndex:indexPath.row];

    if ([self.selectedFilters[indexPath.section][@"filters"] count] >= 1) {
        [self.selectedFilters[indexPath.section][@"filters"] removeAllObjects];
    }

    [self.selectedFilters[indexPath.section][@"filters"] addObject:row];

    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];

    for (int i = 0; i < self.selectedFilters.count; i++) {
        NSDictionary *section = self.selectedFilters[i];

        if ([section[@"filters"] count] <= 0){
            continue;
        }

        if ([section[@"id"] isEqual: @"categories"]) {
            if ([section[@"filters"] count] > 0) {
                [filters setObject:[[NSMutableArray alloc] init] forKey:section[@"id"]];

                for (NSDictionary *category in section[@"filters"]) {
                    [filters[section[@"id"]] addObject:category[@"code"]];
                }
            }
        } else {
            [filters setObject:[[NSNumber alloc] initWithInt:[section[@"filters"][0][@"code"] intValue]] forKey:section[@"id"]];
        }
    }

    return filters;
}

#pragma mark - Event Methods

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization Methods

- (void)initAllFilters {
    NSArray *allFilters = @[@{@"id": @"show_deals", @"name": @"Deals", @"filters":
                                  @[@{@"name": @"Show Deals", @"code": @"1"}]},
                            @{@"id": @"sort_by", @"name": @"Sort By", @"filters":
                                  @[@{@"name": @"Best Matched", @"code": @"0"},
                                    @{@"name": @"Distance", @"code": @"1"},
                                    @{@"name": @"Highest Rated", @"code": @"2"}]},
                            @{@"id": @"distance", @"name": @"Distance", @"filters":
                                  @[@{@"name": @"Auto", @"code": @""},
                                    @{@"name": @"1 Mile", @"code": @"1"},
                                    @{@"name": @"5 Mile", @"code": @"5"},
                                    @{@"name": @"10 Mile", @"code": @"10"},
                                    @{@"name": @"25 Miles", @"code": @"25"}]},
                            @{@"id": @"categories", @"name": @"Categories", @"filters": self.categories}];

    self.allFilters = [[NSMutableArray alloc] initWithArray:allFilters];
}

- (void)initSelectedFilters {
    NSMutableArray *defaults = [NSMutableArray arrayWithArray:
                                @[@{@"id": @"show_deals", @"name": @"Show Deals", @"filters":
                                        [NSMutableArray array]},
                                  @{@"id": @"sort_by", @"name": @"Sort By", @"filters":
                                        [NSMutableArray arrayWithArray:@[@{@"name": @"Best Matched", @"code": @"0"}]]},
                                  @{@"id": @"distance", @"name": @"Distance", @"filters":
                                        [NSMutableArray arrayWithArray:@[@{@"name": @"Auto", @"code": @""}]]},
                                  @{@"id": @"categories", @"name": @"Categories", @"filters": [NSMutableArray array]}]];

    self.selectedFilters = defaults;
}

- (void) initCategories {
    self.categories =
    @[@{@"name": @"Afghan", @"code": @"afghani"},
      @{@"name": @"African", @"code": @"african"},
      @{@"name": @"American, New", @"code": @"newamerican"},
      @{@"name": @"American, Traditional", @"code": @"tradamerican"},
      @{@"name": @"Arabian", @"code": @"arabian"},
      @{@"name": @"Argentine", @"code": @"argentine"},
      @{@"name": @"Armenian", @"code": @"armenian"},
      @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
      @{@"name": @"Asturian", @"code": @"asturian"},
      @{@"name": @"Australian", @"code": @"australian"},
      @{@"name": @"Austrian", @"code": @"austrian"},
      @{@"name": @"Baguettes", @"code": @"baguettes"},
      @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
      @{@"name": @"Barbeque", @"code": @"bbq"},
      @{@"name": @"Basque", @"code": @"basque"},
      @{@"name": @"Bavarian", @"code": @"bavarian"},
      @{@"name": @"Beer Garden", @"code": @"beergarden"},
      @{@"name": @"Beer Hall", @"code": @"beerhall"},
      @{@"name": @"Beisl", @"code": @"beisl"},
      @{@"name": @"Belgian", @"code": @"belgian"},
      @{@"name": @"Bistros", @"code": @"bistros"},
      @{@"name": @"Black Sea", @"code": @"blacksea"},
      @{@"name": @"Brasseries", @"code": @"brasseries"},
      @{@"name": @"Brazilian", @"code": @"brazilian"},
      @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
      @{@"name": @"British", @"code": @"british"},
      @{@"name": @"Buffets", @"code": @"buffets"},
      @{@"name": @"Bulgarian", @"code": @"bulgarian"},
      @{@"name": @"Burgers", @"code": @"burgers"},
      @{@"name": @"Burmese", @"code": @"burmese"},
      @{@"name": @"Cafes", @"code": @"cafes"},
      @{@"name": @"Cafeteria", @"code": @"cafeteria"},
      @{@"name": @"Cajun/Creole", @"code": @"cajun"},
      @{@"name": @"Cambodian", @"code": @"cambodian"},
      @{@"name": @"Canadian", @"code": @"New)"},
      @{@"name": @"Canteen", @"code": @"canteen"},
      @{@"name": @"Caribbean", @"code": @"caribbean"},
      @{@"name": @"Catalan", @"code": @"catalan"},
      @{@"name": @"Chech", @"code": @"chech"},
      @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
      @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
      @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
      @{@"name": @"Chilean", @"code": @"chilean"},
      @{@"name": @"Chinese", @"code": @"chinese"},
      @{@"name": @"Comfort Food", @"code": @"comfortfood"},
      @{@"name": @"Corsican", @"code": @"corsican"},
      @{@"name": @"Creperies", @"code": @"creperies"},
      @{@"name": @"Cuban", @"code": @"cuban"},
      @{@"name": @"Curry Sausage", @"code": @"currysausage"},
      @{@"name": @"Cypriot", @"code": @"cypriot"},
      @{@"name": @"Czech", @"code": @"czech"},
      @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
      @{@"name": @"Danish", @"code": @"danish"},
      @{@"name": @"Delis", @"code": @"delis"},
      @{@"name": @"Diners", @"code": @"diners"},
      @{@"name": @"Dumplings", @"code": @"dumplings"},
      @{@"name": @"Eastern European", @"code": @"eastern_european"},
      @{@"name": @"Ethiopian", @"code": @"ethiopian"},
      @{@"name": @"Fast Food", @"code": @"hotdogs"},
      @{@"name": @"Filipino", @"code": @"filipino"},
      @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
      @{@"name": @"Fondue", @"code": @"fondue"},
      @{@"name": @"Food Court", @"code": @"food_court"},
      @{@"name": @"Food Stands", @"code": @"foodstands"},
      @{@"name": @"French", @"code": @"french"},
      @{@"name": @"French Southwest", @"code": @"sud_ouest"},
      @{@"name": @"Galician", @"code": @"galician"},
      @{@"name": @"Gastropubs", @"code": @"gastropubs"},
      @{@"name": @"Georgian", @"code": @"georgian"},
      @{@"name": @"German", @"code": @"german"},
      @{@"name": @"Giblets", @"code": @"giblets"},
      @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
      @{@"name": @"Greek", @"code": @"greek"},
      @{@"name": @"Halal", @"code": @"halal"},
      @{@"name": @"Hawaiian", @"code": @"hawaiian"},
      @{@"name": @"Heuriger", @"code": @"heuriger"},
      @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
      @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
      @{@"name": @"Hot Dogs", @"code": @"hotdog"},
      @{@"name": @"Hot Pot", @"code": @"hotpot"},
      @{@"name": @"Hungarian", @"code": @"hungarian"},
      @{@"name": @"Iberian", @"code": @"iberian"},
      @{@"name": @"Indian", @"code": @"indpak"},
      @{@"name": @"Indonesian", @"code": @"indonesian"},
      @{@"name": @"International", @"code": @"international"},
      @{@"name": @"Irish", @"code": @"irish"},
      @{@"name": @"Island Pub", @"code": @"island_pub"},
      @{@"name": @"Israeli", @"code": @"israeli"},
      @{@"name": @"Italian", @"code": @"italian"},
      @{@"name": @"Japanese", @"code": @"japanese"},
      @{@"name": @"Jewish", @"code": @"jewish"},
      @{@"name": @"Kebab", @"code": @"kebab"},
      @{@"name": @"Korean", @"code": @"korean"},
      @{@"name": @"Kosher", @"code": @"kosher"},
      @{@"name": @"Kurdish", @"code": @"kurdish"},
      @{@"name": @"Laos", @"code": @"laos"},
      @{@"name": @"Laotian", @"code": @"laotian"},
      @{@"name": @"Latin American", @"code": @"latin"},
      @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
      @{@"name": @"Lyonnais", @"code": @"lyonnais"},
      @{@"name": @"Malaysian", @"code": @"malaysian"},
      @{@"name": @"Meatballs", @"code": @"meatballs"},
      @{@"name": @"Mediterranean", @"code": @"mediterranean"},
      @{@"name": @"Mexican", @"code": @"mexican"},
      @{@"name": @"Middle Eastern", @"code": @"mideastern"},
      @{@"name": @"Milk Bars", @"code": @"milkbars"},
      @{@"name": @"Modern Australian", @"code": @"modern_australian"},
      @{@"name": @"Modern European", @"code": @"modern_european"},
      @{@"name": @"Mongolian", @"code": @"mongolian"},
      @{@"name": @"Moroccan", @"code": @"moroccan"},
      @{@"name": @"New Zealand", @"code": @"newzealand"},
      @{@"name": @"Night Food", @"code": @"nightfood"},
      @{@"name": @"Norcinerie", @"code": @"norcinerie"},
      @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
      @{@"name": @"Oriental", @"code": @"oriental"},
      @{@"name": @"Pakistani", @"code": @"pakistani"},
      @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
      @{@"name": @"Parma", @"code": @"parma"},
      @{@"name": @"Persian/Iranian", @"code": @"persian"},
      @{@"name": @"Peruvian", @"code": @"peruvian"},
      @{@"name": @"Pita", @"code": @"pita"},
      @{@"name": @"Pizza", @"code": @"pizza"},
      @{@"name": @"Polish", @"code": @"polish"},
      @{@"name": @"Portuguese", @"code": @"portuguese"},
      @{@"name": @"Potatoes", @"code": @"potatoes"},
      @{@"name": @"Poutineries", @"code": @"poutineries"},
      @{@"name": @"Pub Food", @"code": @"pubfood"},
      @{@"name": @"Rice", @"code": @"riceshop"},
      @{@"name": @"Romanian", @"code": @"romanian"},
      @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
      @{@"name": @"Rumanian", @"code": @"rumanian"},
      @{@"name": @"Russian", @"code": @"russian"},
      @{@"name": @"Salad", @"code": @"salad"},
      @{@"name": @"Sandwiches", @"code": @"sandwiches"},
      @{@"name": @"Scandinavian", @"code": @"scandinavian"},
      @{@"name": @"Scottish", @"code": @"scottish"},
      @{@"name": @"Seafood", @"code": @"seafood"},
      @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
      @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
      @{@"name": @"Singaporean", @"code": @"singaporean"},
      @{@"name": @"Slovakian", @"code": @"slovakian"},
      @{@"name": @"Soul Food", @"code": @"soulfood"},
      @{@"name": @"Soup", @"code": @"soup"},
      @{@"name": @"Southern", @"code": @"southern"},
      @{@"name": @"Spanish", @"code": @"spanish"},
      @{@"name": @"Steakhouses", @"code": @"steak"},
      @{@"name": @"Sushi Bars", @"code": @"sushi"},
      @{@"name": @"Swabian", @"code": @"swabian"},
      @{@"name": @"Swedish", @"code": @"swedish"},
      @{@"name": @"Swiss Food", @"code": @"swissfood"},
      @{@"name": @"Tabernas", @"code": @"tabernas"},
      @{@"name": @"Taiwanese", @"code": @"taiwanese"},
      @{@"name": @"Tapas Bars", @"code": @"tapas"},
      @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
      @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
      @{@"name": @"Thai", @"code": @"thai"},
      @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
      @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
      @{@"name": @"Trattorie", @"code": @"trattorie"},
      @{@"name": @"Turkish", @"code": @"turkish"},
      @{@"name": @"Ukrainian", @"code": @"ukrainian"},
      @{@"name": @"Uzbek", @"code": @"uzbek"},
      @{@"name": @"Vegan", @"code": @"vegan"},
      @{@"name": @"Vegetarian", @"code": @"vegetarian"},
      @{@"name": @"Venison", @"code": @"venison"},
      @{@"name": @"Vietnamese", @"code": @"vietnamese"},
      @{@"name": @"Wok", @"code": @"wok"},
      @{@"name": @"Wraps", @"code": @"wraps"},
      @{@"name": @"Yugoslav", @"code": @"yugoslav"}];
}

@end
