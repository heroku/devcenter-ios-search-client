#import <Foundation/Foundation.h>

typedef enum {
    TitleSearchScope,
    ContentSearchScope,
} PlantSearchScope;

@interface Plant : NSObject

@property (nonatomic, strong) NSString *commonName;
@property (nonatomic, strong) NSString *latinName;
@property (nonatomic, strong) NSString *plantDescription;

@property (readonly, nonatomic, strong) NSSet *searchTokens;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)plantsWithSearchString:(NSString *)searchString
                   searchScope:(PlantSearchScope)searchScope
                       success:(void (^)(NSSet *plants))success
                       failure:(void (^)(NSError *error))failure;

@end
