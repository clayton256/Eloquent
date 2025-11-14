//
//  FolderUtil.m
//  Eloquent
//
//  Created by Manfred Bergmann on 01.03.16.
//  Copyright © 2016 Crosswire. All rights reserved.
//

#import "FolderUtil.h"
#import "globals.h"

@implementation FolderUtil

static NSURL *libraryFolder = nil;
static NSURL *appSupportFolder = nil;
static NSURL *appInAppSupportFolder = nil;
static NSURL *notesFolder = nil;
static NSURL *indexFolder = nil;
static NSURL *modulesFolder = nil;
static NSURL *installMgrFolder = nil;

+ (nullable NSURL *)urlForLibraryFolder {
    if (libraryFolder == nil) {
        NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory 
                                                                        inDomains:NSUserDomainMask];
        if (urls.count > 0) {
            libraryFolder = urls[0];
        }
    }
    return libraryFolder;
}

+ (nullable NSURL *)urlForLogFolder {
    return [[self urlForLibraryFolder] URLByAppendingPathComponent:@"Logs"];
}

+ (nullable NSURL *)urlForLogfile {
    NSString *logfileName = [NSString stringWithFormat:@"%@.log", APPNAME];
    return [[self urlForLogFolder] URLByAppendingPathComponent:logfileName];
}

+ (nullable NSURL *)urlForAppSupportFolder {
    if (appSupportFolder == nil) {
        NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory 
                                                                        inDomains:NSUserDomainMask];
        if (urls.count > 0) {
            appSupportFolder = urls[0];
        }
    }
    return appSupportFolder;
}

+ (nullable NSURL *)urlForAppInAppSupport {
    if (appInAppSupportFolder == nil) {
        appInAppSupportFolder = [[self urlForAppSupportFolder] URLByAppendingPathComponent:APPNAME];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:appInAppSupportFolder.path]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:appInAppSupportFolder.path 
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error];
            if (error != nil) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                                               reason:[error localizedDescription] 
                                             userInfo:@{NSUnderlyingErrorKey: error}];
            }
        }
    }
    return appInAppSupportFolder;
}

+ (nullable NSURL *)urlForNotesFolder {
    if (notesFolder == nil) {
        notesFolder = [[self urlForAppInAppSupport] URLByAppendingPathComponent:@"Notes"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:notesFolder.path]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:notesFolder.path 
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error];
            if (error != nil) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                                               reason:[error localizedDescription] 
                                             userInfo:@{NSUnderlyingErrorKey: error}];
            }
        }
    }
    return notesFolder;
}

+ (nullable NSURL *)urlForIndexFolder {
    if (indexFolder == nil) {
        indexFolder = [[self urlForAppInAppSupport] URLByAppendingPathComponent:@"Index"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:indexFolder.path]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:indexFolder.path 
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error];
            if (error != nil) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                                               reason:[error localizedDescription] 
                                             userInfo:@{NSUnderlyingErrorKey: error}];
            }
        }
    }
    return indexFolder;
}

+ (nullable NSURL *)urlForModulesFolder {
    if (modulesFolder == nil) {
        modulesFolder = [[self urlForAppSupportFolder] URLByAppendingPathComponent:@"Sword"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:modulesFolder.path]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:modulesFolder.path 
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error];
            if (error != nil) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                                               reason:[error localizedDescription] 
                                             userInfo:@{NSUnderlyingErrorKey: error}];
            }
        }
    }
    return modulesFolder;
}

+ (nullable NSURL *)urlForModsdInModulesFolder {
    NSURL *folder = [[self urlForModulesFolder] URLByAppendingPathComponent:@"mods.d"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folder.path]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:folder.path 
               withIntermediateDirectories:NO 
                                attributes:nil 
                                     error:&error];
        if (error != nil) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                                           reason:[error localizedDescription] 
                                         userInfo:@{NSUnderlyingErrorKey: error}];
        }
    }
    return folder;
}

+ (nullable NSURL *)urlForInstallMgrModulesFolder {
    if (installMgrFolder == nil) {
        installMgrFolder = [[self urlForModulesFolder] URLByAppendingPathComponent:SWINSTALLMGR_NAME];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:installMgrFolder.path]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:installMgrFolder.path 
                   withIntermediateDirectories:NO 
                                    attributes:nil 
                                         error:&error];
            if (error != nil) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException 
                                               reason:[error localizedDescription] 
                                             userInfo:@{NSUnderlyingErrorKey: error}];
            }
        }
    }
    return installMgrFolder;
}

+ (nullable NSURL *)urlForBookmarks {
    return [[self urlForAppInAppSupport] URLByAppendingPathComponent:@"Bookmarklist.plist"];
}

+ (nullable NSURL *)urlForDefaultSession {
    return [[self urlForAppInAppSupport] URLByAppendingPathComponent:@"DefaultSession.mssess"];
}

+ (nullable NSURL *)urlForDefaultSearchBooksets {
    return [[self urlForAppInAppSupport] URLByAppendingPathComponent:@"DefaultSearchBookSets.plist"];
}

@end
