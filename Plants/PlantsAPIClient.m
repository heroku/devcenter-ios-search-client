#import "PlantsAPIClient.h"

#import "AFJSONRequestOperation.h"

static NSString * const kPlantsAPIClientBaseURLString = @"http://localhost:5000/";

@implementation PlantsAPIClient

+ (PlantsAPIClient *)sharedClient {
    static PlantsAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PlantsAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kPlantsAPIClientBaseURLString]];
        [_sharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [_sharedClient setDefaultHeader:@"Accept" value:@"application/json"];
    });
    
    return _sharedClient;
}

@end
