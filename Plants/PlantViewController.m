#import "PlantViewController.h"
#import "Plant.h"

@implementation PlantViewController {
    Plant *_plant;
}
@synthesize latinNameLabel = _latinNameLabel;
@synthesize commonNameLabel = _commonNameLabel;
@synthesize descriptionTextView = _descriptionTextView;

- (id)initWithPlant:(Plant *)plant {
    self = [super initWithNibName:@"PlantView" bundle:nil];
    if (!self) {
        return nil;
    }
    
    _plant = plant;
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _plant.latinName;
    
    self.latinNameLabel.text = _plant.latinName;
    self.commonNameLabel.text = _plant.commonName;
    self.descriptionTextView.text = _plant.plantDescription;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
