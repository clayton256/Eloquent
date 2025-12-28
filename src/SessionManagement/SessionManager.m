//
// Created by mbergmann on 28.07.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <FooLogger/CocoLogger.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "SessionManager.h"
#import "ProtocolHelper.h"
#import "HostableViewController.h"
#import "WindowHostController.h"
#import "Session.h"
#import "globals.h"
#import "MBPreferenceController.h"
#import "FolderUtil.h"
#import "SearchTextObject.h"

@interface SessionManager ()

@property (strong, nonatomic) Session *session;

@end

@implementation SessionManager

+ (SessionManager *)defaultManager {
    static SessionManager *instance = nil;
    if (instance == nil) {
        instance = [[SessionManager alloc] init];
    }
    return instance;
}

- (id)initWithUrl:(NSURL *)anUrl {
    self = [super init];
    if(self) {
        self.session = [[Session alloc] initWithURL:anUrl];
    }
    return self;
}

- (id)init {
    // load session path from defaults
    NSURL *url = [UserDefaults objectForKey:DefaultsSessionPath] == nil ?
        [FolderUtil urlForDefaultSession] : [NSURL URLWithString:[UserDefaults objectForKey:DefaultsSessionPath]];

    return [self initWithUrl:url];
}

- (bool)hasWindows {
    return self.session.windows != nil && self.session.windows.count > 0;
}

- (bool)hasUnsavedContent {
    BOOL unsavedContent = NO;
    for(WindowHostController *hc in self.session.windows) {
        if([hc hasUnsavedContent]) {
            unsavedContent = YES;
            break;
        }
    }
    return unsavedContent;
}

- (NSArray *)retrieveWindows {
    return [self.session.windows copy];
}

/**
* Saves session to url as in session.url
*/
- (void)saveSession {
    // encode all windows
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
    [archiver encodeObject:self.session.windows forKey:@"WindowsEncoded"];
    [archiver finishEncoding];
    NSData *data = [archiver encodedData];

    // write data object
    if (![data writeToURL:self.session.url atomically:NO]) {
        CocoLog(LEVEL_ERR, @"Unable to write session to: %@", [self.session.url absoluteString]);
    }
}

/**
* Saves session to user defined file. As via file requester.
* The defined url is then taken as default session url.
*/
- (void)saveSessionAs {
    NSSavePanel *sp = [NSSavePanel savePanel];
    [sp setTitle:NSLocalizedString(@"SaveMSSession", @"")];
    [sp setCanCreateDirectories:YES];
    [sp setAllowedContentTypes:@[[UTType typeWithFilenameExtension:@"mssess"]]];
    if([sp runModal] == NSModalResponseOK) {
        self.session.url = [sp URL];
        [self saveSession];
        // this session we have loaded
        [UserDefaults setObject:[self.session.url absoluteString] forKey:DefaultsSessionPath];
    }
}

/**
* Saves session as default session to default session url.
*/
- (void)saveAsDefaultSession {
    self.session.url = [FolderUtil urlForDefaultSession];
    [self saveSession];

    // mark this as default session
    [UserDefaults setObject:[self.session.url absoluteString] forKey:DefaultsSessionPath];
}

/**
* Loads session from default session url.
*/
- (void)loadDefaultSession {
    [self checkSessionSaveOnLoad];
    [self closeAllWindows];

    self.session.url = [FolderUtil urlForDefaultSession];
    // mark as default session
    [UserDefaults setObject:[self.session.url absoluteString] forKey:DefaultsSessionPath];

    [self loadSession];
    [self showAllWindows];
}

/**
* Loads session from user defined file. Ask user via file requester.
* Sets the defined url as default session.
*/
- (void)loadSessionFrom {
    [self checkSessionSaveOnLoad];
    [self closeAllWindows];

    // open load panel
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setCanCreateDirectories:NO];
    [op setAllowedContentTypes:@[[UTType typeWithFilenameExtension:@"mssess"]]];
    [op setTitle:NSLocalizedString(@"LoadMSSession", @"")];
    [op setAllowsMultipleSelection:NO];
    [op setCanChooseDirectories:NO];
    [op setAllowsOtherFileTypes:NO];
    if([op runModal] == NSModalResponseOK) {
        // close all existing windows
        for(NSWindowController *wc in self.session.windows) {
            [wc close];
        }

        // get file
        self.session.url = [op URL];
        // this session we will loaded
        [UserDefaults setObject:[self.session.url absoluteString] forKey:DefaultsSessionPath];
        // load session
        [self loadSession];
        [self showAllWindows];
    }
}

/**
* Loads the session as is defined in session.url.
*/
- (void)loadSession {
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[self.session.url path]]) {
        CocoLog(LEVEL_INFO, @"No such session file at: %@", [self.session.url absoluteString]);
        return;
    }

    @try {
        NSData *data = [NSData dataWithContentsOfURL:self.session.url];
        if (data == nil) @throw [NSException exceptionWithName:@"SessionLoadError" reason:@"Unable to load session!" userInfo:nil];

        NSError *error = nil;
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
        [unarchiver setRequiresSecureCoding:NO];
        NSArray *windows = [unarchiver decodeObjectForKey:@"WindowsEncoded"];
        
        self.session.windows = windows;
    } @catch (NSException *e) {
        CocoLog(LEVEL_ERR, @"Unable to load session: %@", [self.session.url absoluteString]);
        CocoLog(LEVEL_ERR, @"Error reason: %@", [e reason]);
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:NSLocalizedString(@"SessionLoadError", @"")];
        [alert setInformativeText:NSLocalizedString(@"SessionLoadErrorText", @"")];
        [alert addButtonWithTitle:NSLocalizedString(@"OK", @"")];
        [alert runModal];
    }
}

- (void)checkSessionSaveOnLoad {
    // if there are any open windows, a session is currently open
    // ask the user if we wants to save the open session first
    if([self.session.windows count] > 0) {
        // show Alert
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:NSLocalizedString(@"SessionStillOpen", @"")];
        [alert setInformativeText:NSLocalizedString(@"WantToSaveTheSessionBeforeClosing", @"")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"")];
        [alert addButtonWithTitle:NSLocalizedString(@"No", @"")];
        if([alert runModal] == NSAlertFirstButtonReturn) {
            // save session
            [self saveSession];
        }
    }
}

- (void)addDelegateToHosts:(id)aDelegate {
    for(NSWindowController *wc in self.session.windows) {
        if([wc isKindOfClass:[WindowHostController class]]) {
            [(WindowHostController *)wc setDelegate:aDelegate];
        }
    }
}

- (void)showAllWindows {
    for(id entry in self.session.windows) {
        if([entry isKindOfClass:[WindowHostController class]]) {
            [(WindowHostController *)entry showWindow:self];
        }
    }
}

- (void)closeAllWindows {
    for(id entry in self.session.windows) {
        if([entry isKindOfClass:[WindowHostController class]]) {
            [(WindowHostController *)entry close];
        }
    }
}

- (void)addWindow:(WindowHostController *)aWindow {
    self.session.windows = [self.session.windows arrayByAddingObject:aWindow];
}

- (void)removeWindow:(WindowHostController *)aWindow {
    NSMutableArray *windows = [self.session.windows mutableCopy];
    [windows removeObject:aWindow];

    self.session.windows = [NSArray arrayWithArray:windows];
}

- (void)saveContent {
    for(WindowHostController *hc in self.session.windows) {
        if([hc hasUnsavedContent]) {
            [hc saveContent];
        }
    }
}

@end
