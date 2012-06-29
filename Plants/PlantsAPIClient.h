#import "AFHTTPClient.h"

@interface PlantsAPIClient : AFHTTPClient

+ (PlantsAPIClient *)sharedClient;

@end
