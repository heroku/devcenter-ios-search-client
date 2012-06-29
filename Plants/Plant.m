#import "Plant.h"

#import "PlantsAPIClient.h"

@implementation Plant
@synthesize commonName = _commonName;
@synthesize latinName = _latinName;
@synthesize plantDescription = _plantDescription;
@synthesize searchTokens = _searchTokens;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _commonName = [attributes valueForKey:@"common_name"];
    _latinName = [attributes valueForKey:@"latin_name"];
    _plantDescription = [attributes valueForKey:@"description"];

    return self;
}

- (NSUInteger)hash {
    return [_latinName hash];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [[object latinName] isEqualToString:[self latinName]];
}

+ (void)plantsWithSearchString:(NSString *)searchString
                   searchScope:(PlantSearchScope)searchScope
                       success:(void (^)(NSSet *plants))success
                       failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setValue:searchString forKey:@"q"];
    switch (searchScope) {
        case TitleSearchScope:
            [mutableParameters setValue:@"title" forKey:@"scope"];
            break;
        case ContentSearchScope:
            [mutableParameters setValue:@"content" forKey:@"scope"];
            break;
    }

    [[PlantsAPIClient sharedClient] getPath:@"/plants/search" parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableSet *mutablePlants = [NSMutableSet set];
        for (NSDictionary *attributes in [JSON valueForKey:@"plants"]) {
            Plant *plant = [[Plant alloc] initWithAttributes:attributes];
            [mutablePlants addObject:plant];
        }
        
        if (success) {
            success(mutablePlants);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
