//
//  FolderUtilTests.m
//  EloquentTests
//
//  Created on 14.11.25.
//  Copyright © 2025 Crosswire. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FolderUtil.h"

@interface FolderUtilTests : XCTestCase

@end

@implementation FolderUtilTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Library Folder Tests

- (void)testUrlForLibraryFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *libraryURL = [FolderUtil urlForLibraryFolder];
    
    // Then
    XCTAssertNotNil(libraryURL, @"Library folder URL should not be nil");
}

- (void)testUrlForLibraryFolder_ReturnsValidPath {
    // Given/When
    NSURL *libraryURL = [FolderUtil urlForLibraryFolder];
    
    // Then
    XCTAssertTrue([libraryURL isFileURL], @"Library URL should be a file URL");
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:libraryURL.path], 
                  @"Library folder should exist at path: %@", libraryURL.path);
}

- (void)testUrlForLibraryFolder_ReturnsSameInstanceOnMultipleCalls {
    // Given/When
    NSURL *firstCall = [FolderUtil urlForLibraryFolder];
    NSURL *secondCall = [FolderUtil urlForLibraryFolder];
    
    // Then
    XCTAssertEqual(firstCall, secondCall, @"Should return the same cached instance");
}

#pragma mark - Log Folder Tests

- (void)testUrlForLogFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *logFolderURL = [FolderUtil urlForLogFolder];
    
    // Then
    XCTAssertNotNil(logFolderURL, @"Log folder URL should not be nil");
}

- (void)testUrlForLogFolder_ContainsLogsComponent {
    // Given/When
    NSURL *logFolderURL = [FolderUtil urlForLogFolder];
    
    // Then
    XCTAssertTrue([logFolderURL.lastPathComponent isEqualToString:@"Logs"], 
                  @"Log folder URL should end with 'Logs', got: %@", logFolderURL.lastPathComponent);
}

- (void)testUrlForLogFolder_IsSubpathOfLibraryFolder {
    // Given
    NSURL *libraryURL = [FolderUtil urlForLibraryFolder];
    NSURL *logFolderURL = [FolderUtil urlForLogFolder];
    
    // When/Then
    XCTAssertTrue([logFolderURL.path hasPrefix:libraryURL.path], 
                  @"Log folder should be subpath of library folder");
}

#pragma mark - Logfile Tests

- (void)testUrlForLogfile_ReturnsNonNilURL {
    // Given/When
    NSURL *logfileURL = [FolderUtil urlForLogfile];
    
    // Then
    XCTAssertNotNil(logfileURL, @"Logfile URL should not be nil");
}

- (void)testUrlForLogfile_HasLogExtension {
    // Given/When
    NSURL *logfileURL = [FolderUtil urlForLogfile];
    
    // Then
    XCTAssertTrue([logfileURL.pathExtension isEqualToString:@"log"], 
                  @"Logfile should have .log extension, got: %@", logfileURL.pathExtension);
}

- (void)testUrlForLogfile_IsSubpathOfLogFolder {
    // Given
    NSURL *logFolderURL = [FolderUtil urlForLogFolder];
    NSURL *logfileURL = [FolderUtil urlForLogfile];
    
    // When/Then
    XCTAssertTrue([logfileURL.path hasPrefix:logFolderURL.path], 
                  @"Logfile should be subpath of log folder");
}

#pragma mark - Application Support Folder Tests

- (void)testUrlForAppSupportFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *appSupportURL = [FolderUtil urlForAppSupportFolder];
    
    // Then
    XCTAssertNotNil(appSupportURL, @"App support folder URL should not be nil");
}

- (void)testUrlForAppSupportFolder_ReturnsValidPath {
    // Given/When
    NSURL *appSupportURL = [FolderUtil urlForAppSupportFolder];
    
    // Then
    XCTAssertTrue([appSupportURL isFileURL], @"App support URL should be a file URL");
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:appSupportURL.path], 
                  @"App support folder should exist at path: %@", appSupportURL.path);
}

- (void)testUrlForAppSupportFolder_ReturnsSameInstanceOnMultipleCalls {
    // Given/When
    NSURL *firstCall = [FolderUtil urlForAppSupportFolder];
    NSURL *secondCall = [FolderUtil urlForAppSupportFolder];
    
    // Then
    XCTAssertEqual(firstCall, secondCall, @"Should return the same cached instance");
}

#pragma mark - App In App Support Tests

- (void)testUrlForAppInAppSupport_ReturnsNonNilURL {
    // Given/When
    NSURL *appInAppSupportURL = [FolderUtil urlForAppInAppSupport];
    
    // Then
    XCTAssertNotNil(appInAppSupportURL, @"App in app support URL should not be nil");
}

- (void)testUrlForAppInAppSupport_CreatesDirectoryIfNotExists {
    // Given/When
    NSURL *appInAppSupportURL = [FolderUtil urlForAppInAppSupport];
    
    // Then
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:appInAppSupportURL.path 
                                                        isDirectory:&isDirectory];
    XCTAssertTrue(exists, @"App in app support folder should exist");
    XCTAssertTrue(isDirectory, @"App in app support path should be a directory");
}

- (void)testUrlForAppInAppSupport_IsSubpathOfAppSupportFolder {
    // Given
    NSURL *appSupportURL = [FolderUtil urlForAppSupportFolder];
    NSURL *appInAppSupportURL = [FolderUtil urlForAppInAppSupport];
    
    // When/Then
    XCTAssertTrue([appInAppSupportURL.path hasPrefix:appSupportURL.path], 
                  @"App in app support should be subpath of app support folder");
}

#pragma mark - Notes Folder Tests

- (void)testUrlForNotesFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *notesFolderURL = [FolderUtil urlForNotesFolder];
    
    // Then
    XCTAssertNotNil(notesFolderURL, @"Notes folder URL should not be nil");
}

- (void)testUrlForNotesFolder_CreatesDirectoryIfNotExists {
    // Given/When
    NSURL *notesFolderURL = [FolderUtil urlForNotesFolder];
    
    // Then
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:notesFolderURL.path 
                                                        isDirectory:&isDirectory];
    XCTAssertTrue(exists, @"Notes folder should exist");
    XCTAssertTrue(isDirectory, @"Notes path should be a directory");
}

- (void)testUrlForNotesFolder_HasCorrectName {
    // Given/When
    NSURL *notesFolderURL = [FolderUtil urlForNotesFolder];
    
    // Then
    XCTAssertTrue([notesFolderURL.lastPathComponent isEqualToString:@"Notes"], 
                  @"Notes folder should be named 'Notes', got: %@", notesFolderURL.lastPathComponent);
}

#pragma mark - Index Folder Tests

- (void)testUrlForIndexFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *indexFolderURL = [FolderUtil urlForIndexFolder];
    
    // Then
    XCTAssertNotNil(indexFolderURL, @"Index folder URL should not be nil");
}

- (void)testUrlForIndexFolder_CreatesDirectoryIfNotExists {
    // Given/When
    NSURL *indexFolderURL = [FolderUtil urlForIndexFolder];
    
    // Then
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:indexFolderURL.path 
                                                        isDirectory:&isDirectory];
    XCTAssertTrue(exists, @"Index folder should exist");
    XCTAssertTrue(isDirectory, @"Index path should be a directory");
}

- (void)testUrlForIndexFolder_HasCorrectName {
    // Given/When
    NSURL *indexFolderURL = [FolderUtil urlForIndexFolder];
    
    // Then
    XCTAssertTrue([indexFolderURL.lastPathComponent isEqualToString:@"Index"], 
                  @"Index folder should be named 'Index', got: %@", indexFolderURL.lastPathComponent);
}

#pragma mark - Modules Folder Tests

- (void)testUrlForModulesFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *modulesFolderURL = [FolderUtil urlForModulesFolder];
    
    // Then
    XCTAssertNotNil(modulesFolderURL, @"Modules folder URL should not be nil");
}

- (void)testUrlForModulesFolder_CreatesDirectoryIfNotExists {
    // Given/When
    NSURL *modulesFolderURL = [FolderUtil urlForModulesFolder];
    
    // Then
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:modulesFolderURL.path 
                                                        isDirectory:&isDirectory];
    XCTAssertTrue(exists, @"Modules folder should exist");
    XCTAssertTrue(isDirectory, @"Modules path should be a directory");
}

- (void)testUrlForModulesFolder_HasCorrectName {
    // Given/When
    NSURL *modulesFolderURL = [FolderUtil urlForModulesFolder];
    
    // Then
    XCTAssertTrue([modulesFolderURL.lastPathComponent isEqualToString:@"Sword"], 
                  @"Modules folder should be named 'Sword', got: %@", modulesFolderURL.lastPathComponent);
}

- (void)testUrlForModulesFolder_IsSubpathOfAppSupportFolder {
    // Given
    NSURL *appSupportURL = [FolderUtil urlForAppSupportFolder];
    NSURL *modulesFolderURL = [FolderUtil urlForModulesFolder];
    
    // When/Then
    XCTAssertTrue([modulesFolderURL.path hasPrefix:appSupportURL.path], 
                  @"Modules folder should be subpath of app support folder");
}

#pragma mark - Mods.d Folder Tests

- (void)testUrlForModsdInModulesFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *modsdFolderURL = [FolderUtil urlForModsdInModulesFolder];
    
    // Then
    XCTAssertNotNil(modsdFolderURL, @"Mods.d folder URL should not be nil");
}

- (void)testUrlForModsdInModulesFolder_CreatesDirectoryIfNotExists {
    // Given/When
    NSURL *modsdFolderURL = [FolderUtil urlForModsdInModulesFolder];
    
    // Then
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:modsdFolderURL.path 
                                                        isDirectory:&isDirectory];
    XCTAssertTrue(exists, @"Mods.d folder should exist");
    XCTAssertTrue(isDirectory, @"Mods.d path should be a directory");
}

- (void)testUrlForModsdInModulesFolder_HasCorrectName {
    // Given/When
    NSURL *modsdFolderURL = [FolderUtil urlForModsdInModulesFolder];
    
    // Then
    XCTAssertTrue([modsdFolderURL.lastPathComponent isEqualToString:@"mods.d"], 
                  @"Mods.d folder should be named 'mods.d', got: %@", modsdFolderURL.lastPathComponent);
}

- (void)testUrlForModsdInModulesFolder_IsSubpathOfModulesFolder {
    // Given
    NSURL *modulesFolderURL = [FolderUtil urlForModulesFolder];
    NSURL *modsdFolderURL = [FolderUtil urlForModsdInModulesFolder];
    
    // When/Then
    XCTAssertTrue([modsdFolderURL.path hasPrefix:modulesFolderURL.path], 
                  @"Mods.d folder should be subpath of modules folder");
}

#pragma mark - Install Manager Folder Tests

- (void)testUrlForInstallMgrModulesFolder_ReturnsNonNilURL {
    // Given/When
    NSURL *installMgrFolderURL = [FolderUtil urlForInstallMgrModulesFolder];
    
    // Then
    XCTAssertNotNil(installMgrFolderURL, @"Install manager folder URL should not be nil");
}

- (void)testUrlForInstallMgrModulesFolder_CreatesDirectoryIfNotExists {
    // Given/When
    NSURL *installMgrFolderURL = [FolderUtil urlForInstallMgrModulesFolder];
    
    // Then
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:installMgrFolderURL.path 
                                                        isDirectory:&isDirectory];
    XCTAssertTrue(exists, @"Install manager folder should exist");
    XCTAssertTrue(isDirectory, @"Install manager path should be a directory");
}

- (void)testUrlForInstallMgrModulesFolder_IsSubpathOfModulesFolder {
    // Given
    NSURL *modulesFolderURL = [FolderUtil urlForModulesFolder];
    NSURL *installMgrFolderURL = [FolderUtil urlForInstallMgrModulesFolder];
    
    // When/Then
    XCTAssertTrue([installMgrFolderURL.path hasPrefix:modulesFolderURL.path], 
                  @"Install manager folder should be subpath of modules folder");
}

#pragma mark - Bookmarks Tests

- (void)testUrlForBookmarks_ReturnsNonNilURL {
    // Given/When
    NSURL *bookmarksURL = [FolderUtil urlForBookmarks];
    
    // Then
    XCTAssertNotNil(bookmarksURL, @"Bookmarks URL should not be nil");
}

- (void)testUrlForBookmarks_HasCorrectFilename {
    // Given/When
    NSURL *bookmarksURL = [FolderUtil urlForBookmarks];
    
    // Then
    XCTAssertTrue([bookmarksURL.lastPathComponent isEqualToString:@"Bookmarklist.plist"], 
                  @"Bookmarks file should be named 'Bookmarklist.plist', got: %@", 
                  bookmarksURL.lastPathComponent);
}

- (void)testUrlForBookmarks_HasPlistExtension {
    // Given/When
    NSURL *bookmarksURL = [FolderUtil urlForBookmarks];
    
    // Then
    XCTAssertTrue([bookmarksURL.pathExtension isEqualToString:@"plist"], 
                  @"Bookmarks file should have .plist extension, got: %@", 
                  bookmarksURL.pathExtension);
}

- (void)testUrlForBookmarks_IsInAppInAppSupportFolder {
    // Given
    NSURL *appInAppSupportURL = [FolderUtil urlForAppInAppSupport];
    NSURL *bookmarksURL = [FolderUtil urlForBookmarks];
    
    // When/Then
    XCTAssertTrue([bookmarksURL.path hasPrefix:appInAppSupportURL.path], 
                  @"Bookmarks file should be in app in app support folder");
}

#pragma mark - Default Session Tests

- (void)testUrlForDefaultSession_ReturnsNonNilURL {
    // Given/When
    NSURL *sessionURL = [FolderUtil urlForDefaultSession];
    
    // Then
    XCTAssertNotNil(sessionURL, @"Default session URL should not be nil");
}

- (void)testUrlForDefaultSession_HasCorrectFilename {
    // Given/When
    NSURL *sessionURL = [FolderUtil urlForDefaultSession];
    
    // Then
    XCTAssertTrue([sessionURL.lastPathComponent isEqualToString:@"DefaultSession.mssess"], 
                  @"Default session file should be named 'DefaultSession.mssess', got: %@", 
                  sessionURL.lastPathComponent);
}

- (void)testUrlForDefaultSession_HasMssessExtension {
    // Given/When
    NSURL *sessionURL = [FolderUtil urlForDefaultSession];
    
    // Then
    XCTAssertTrue([sessionURL.pathExtension isEqualToString:@"mssess"], 
                  @"Default session file should have .mssess extension, got: %@", 
                  sessionURL.pathExtension);
}

- (void)testUrlForDefaultSession_IsInAppInAppSupportFolder {
    // Given
    NSURL *appInAppSupportURL = [FolderUtil urlForAppInAppSupport];
    NSURL *sessionURL = [FolderUtil urlForDefaultSession];
    
    // When/Then
    XCTAssertTrue([sessionURL.path hasPrefix:appInAppSupportURL.path], 
                  @"Default session file should be in app in app support folder");
}

#pragma mark - Default Search Booksets Tests

- (void)testUrlForDefaultSearchBooksets_ReturnsNonNilURL {
    // Given/When
    NSURL *booksetsURL = [FolderUtil urlForDefaultSearchBooksets];
    
    // Then
    XCTAssertNotNil(booksetsURL, @"Default search booksets URL should not be nil");
}

- (void)testUrlForDefaultSearchBooksets_HasCorrectFilename {
    // Given/When
    NSURL *booksetsURL = [FolderUtil urlForDefaultSearchBooksets];
    
    // Then
    XCTAssertTrue([booksetsURL.lastPathComponent isEqualToString:@"DefaultSearchBookSets.plist"], 
                  @"Default search booksets file should be named 'DefaultSearchBookSets.plist', got: %@", 
                  booksetsURL.lastPathComponent);
}

- (void)testUrlForDefaultSearchBooksets_HasPlistExtension {
    // Given/When
    NSURL *booksetsURL = [FolderUtil urlForDefaultSearchBooksets];
    
    // Then
    XCTAssertTrue([booksetsURL.pathExtension isEqualToString:@"plist"], 
                  @"Default search booksets file should have .plist extension, got: %@", 
                  booksetsURL.pathExtension);
}

- (void)testUrlForDefaultSearchBooksets_IsInAppInAppSupportFolder {
    // Given
    NSURL *appInAppSupportURL = [FolderUtil urlForAppInAppSupport];
    NSURL *booksetsURL = [FolderUtil urlForDefaultSearchBooksets];
    
    // When/Then
    XCTAssertTrue([booksetsURL.path hasPrefix:appInAppSupportURL.path], 
                  @"Default search booksets file should be in app in app support folder");
}

#pragma mark - Integration Tests

- (void)testAllFolderURLs_AreValid {
    // Given/When
    NSArray<NSURL *> *allURLs = @[
        [FolderUtil urlForLibraryFolder],
        [FolderUtil urlForLogFolder],
        [FolderUtil urlForLogfile],
        [FolderUtil urlForAppSupportFolder],
        [FolderUtil urlForAppInAppSupport],
        [FolderUtil urlForNotesFolder],
        [FolderUtil urlForIndexFolder],
        [FolderUtil urlForModulesFolder],
        [FolderUtil urlForModsdInModulesFolder],
        [FolderUtil urlForInstallMgrModulesFolder],
        [FolderUtil urlForBookmarks],
        [FolderUtil urlForDefaultSession],
        [FolderUtil urlForDefaultSearchBooksets]
    ];
    
    // Then
    for (NSURL *url in allURLs) {
        XCTAssertNotNil(url, @"URL should not be nil: %@", url);
        XCTAssertTrue([url isFileURL], @"URL should be a file URL: %@", url);
        XCTAssertTrue(url.path.length > 0, @"URL path should not be empty: %@", url);
    }
}

- (void)testFolderHierarchy_IsCorrect {
    // Given
    NSURL *appInAppSupport = [FolderUtil urlForAppInAppSupport];
    NSURL *notes = [FolderUtil urlForNotesFolder];
    NSURL *index = [FolderUtil urlForIndexFolder];
    NSURL *modules = [FolderUtil urlForModulesFolder];
    NSURL *modsd = [FolderUtil urlForModsdInModulesFolder];
    NSURL *installMgr = [FolderUtil urlForInstallMgrModulesFolder];
    
    // Then - verify hierarchy
    XCTAssertTrue([notes.path hasPrefix:appInAppSupport.path], 
                  @"Notes should be under app in app support");
    XCTAssertTrue([index.path hasPrefix:appInAppSupport.path], 
                  @"Index should be under app in app support");
    XCTAssertTrue([modsd.path hasPrefix:modules.path], 
                  @"Mods.d should be under modules");
    XCTAssertTrue([installMgr.path hasPrefix:modules.path], 
                  @"Install manager should be under modules");
}

@end
