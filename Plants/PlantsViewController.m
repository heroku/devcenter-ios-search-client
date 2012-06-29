#import "PlantsViewController.h"
#import "PlantViewController.h"

#import "Plant.h"

@interface PlantsViewController ()
@property (readwrite, nonatomic, strong) NSSet *contents;
@property (readwrite, nonatomic, strong) NSArray *filteredContents;

- (void)filterContentsWithSearchString:(NSString *)searchString searchScope:(PlantSearchScope)searchScope;
@end

@implementation PlantsViewController
@synthesize contents = _contents;
@synthesize filteredContents = _filteredContents;

- (id)init {
    self = [super initWithNibName:@"PlantsView" bundle:nil];
    if (!self) {
        return nil;
    }
    
    _contents = [NSSet set];
    _filteredContents = [NSArray array];
    
    return self;
}

- (void)setFilteredContents:(NSArray *)filteredContents {
    NSSortDescriptor *latinNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"latinName" ascending:YES selector:@selector(localizedStandardCompare:)];

    _filteredContents = [filteredContents sortedArrayUsingDescriptors:[NSArray arrayWithObject:latinNameSortDescriptor]];
    if ([self.searchDisplayController isActive]) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)filterContentsWithSearchString:(NSString *)searchString searchScope:(PlantSearchScope)searchScope {
    if ([[searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return;
    }
    
    if (searchScope == TitleSearchScope) {
        NSPredicate *latinNamePredicate = [NSPredicate predicateWithFormat:@"latinName BEGINSWITH[cd] %@", searchString];
        NSPredicate *commonNamePredicate = [NSPredicate predicateWithFormat:@"commonName BEGINSWITH[cd] %@", searchString];
        
        self.filteredContents = [[self.contents filteredSetUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:latinNamePredicate, commonNamePredicate, nil]]] allObjects]; 
    }
    
    [Plant plantsWithSearchString:searchString searchScope:searchScope success:^(NSSet *plants) {
        self.contents = [self.contents setByAddingObjectsFromSet:plants];
        self.filteredContents = [plants allObjects];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filteredContents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case TitleSearchScope:
            return 50.0f;
        case ContentSearchScope:
            return 100.0f;
        default:
            return tableView.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Plant *plant = [_filteredContents objectAtIndex:indexPath.row];    
    cell.textLabel.text = plant.latinName;
    
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case TitleSearchScope:
            cell.detailTextLabel.text = plant.commonName;
            cell.detailTextLabel.numberOfLines = 1;
            cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:11.0f];
            break;
        case ContentSearchScope:
            cell.detailTextLabel.text = plant.plantDescription;
            cell.detailTextLabel.numberOfLines = 4;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0f];
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Plant *plant = [self.filteredContents objectAtIndex:indexPath.row];
    PlantViewController *viewController = [[PlantViewController alloc] initWithPlant:plant];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentsWithSearchString:controller.searchBar.text searchScope:controller.searchBar.selectedScopeButtonIndex];

    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchScope 
{
    [self filterContentsWithSearchString:controller.searchBar.text searchScope:controller.searchBar.selectedScopeButtonIndex];

    return NO;
}

@end
