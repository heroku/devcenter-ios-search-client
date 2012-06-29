#import <UIKit/UIKit.h>

@class Plant;

@interface PlantViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *latinNameLabel; 
@property (nonatomic, weak) IBOutlet UILabel *commonNameLabel; 
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView; 

- (id)initWithPlant:(Plant *)plant;

@end
