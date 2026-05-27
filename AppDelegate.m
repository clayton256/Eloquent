//
//  AppDelegate.m
//  Eloquent
//
//  Created by Mark Clayton on 5/21/26.
//  Copyright © 2026 Crosswire. All rights reserved.
//

// AppDelegate.m
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    for (NSURL *url in urls) {
        if ([[url.scheme lowercaseString] isEqualToString:@"eloquent"]) {
            [self routeDeepLinkURL:url];
        }
    }
}

- (void)routeDeepLinkURL:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];

    NSMutableArray<NSString *> *cleanSegments = [NSMutableArray array];
    for (NSString *s in url.pathComponents) {
        if (![s isEqualToString:@"/"]) { [cleanSegments addObject:s]; }
    }

    NSMutableDictionary<NSString *, NSString *> *query = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in components.queryItems ?: @[]) {
        if (item.name && item.value) { query[item.name] = item.value; }
    }

    NSString *first = cleanSegments.firstObject.lowercaseString;
    if ([first isEqualToString:@"passage"]) {
        NSString *reference = cleanSegments.count > 1 ? cleanSegments[1] : @"";
        NSString *version = query[@"version"];
        [self openPassage:reference version:version];
    } else if ([first isEqualToString:@"module"]) {
        NSString *name = cleanSegments.count > 1 ? cleanSegments[1] : @"";
        [self openModule:name];
    } else if ([first isEqualToString:@"search"]) {
        NSString *q = query[@"q"] ?: @"";
        NSString *inVersion = query[@"in"];
        [self openSearch:q inVersion:inVersion];
    } else {
        // Unknown route
    }
}

#pragma mark - Navigation helpers

- (void)openPassage:(NSString *)reference version:(NSString *)version {
    // Example navigation — adapt to your structure
    // UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    // UIViewController *vc = [PassageViewController controllerWithReference:reference version:version];
    // [nav pushViewController:vc animated:YES];
}

- (void)openModule:(NSString *)name {
    // TODO
}

- (void)openSearch:(NSString *)query inVersion:(NSString *)version {
    // TODO
}

@end

