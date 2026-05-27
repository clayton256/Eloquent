//  SearchManager.m
//  Eloquent
//
//  Scaffolded by assistant on 5/21/26.
//

#import "SearchManager.h"

@implementation SearchManager

+ (instancetype)shared {
    static SearchManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}

- (nullable NSString *)searchFor:(NSString *)query inVersion:(NSString * _Nullable)version error:(NSError * _Nullable * _Nullable)error {
    // TODO: Replace with your real search implementation.
    NSString *usedVersion = (version.length > 0) ? version : @"default";
    return [NSString stringWithFormat:@"Search '%@' in %@ completed.", query, usedVersion];
}

- (void)openPassage:(NSString *)reference version:(NSString * _Nullable)version {
    // TODO: Bridge to your macOS UI to open the passage. For now, this is a no-op.
    (void)reference; (void)version;
}

@end
