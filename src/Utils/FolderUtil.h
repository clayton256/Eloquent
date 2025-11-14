//
//  FolderUtil.h
//  Eloquent
//
//  Created by Manfred Bergmann on 01.03.16.
//  Copyright © 2016 Crosswire. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FolderUtil : NSObject

+ (nullable NSURL *)urlForLibraryFolder;
+ (nullable NSURL *)urlForLogFolder;
+ (nullable NSURL *)urlForLogfile;
+ (nullable NSURL *)urlForAppSupportFolder;
+ (nullable NSURL *)urlForAppInAppSupport;
+ (nullable NSURL *)urlForNotesFolder;
+ (nullable NSURL *)urlForIndexFolder;
+ (nullable NSURL *)urlForModulesFolder;
+ (nullable NSURL *)urlForModsdInModulesFolder;
+ (nullable NSURL *)urlForInstallMgrModulesFolder;
+ (nullable NSURL *)urlForBookmarks;
+ (nullable NSURL *)urlForDefaultSession;
+ (nullable NSURL *)urlForDefaultSearchBooksets;

@end

NS_ASSUME_NONNULL_END
