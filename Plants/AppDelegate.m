#import "AppDelegate.h"

#import "PlantsViewController.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PlantsViewController *viewController = [[PlantsViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
