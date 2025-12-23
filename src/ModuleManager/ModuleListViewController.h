
#import <Cocoa/Cocoa.h>
#import <CocoPCRE/CocoPCRE.h>
#import <FooLogger/CocoLogger.h>
#import <ObjCSword/SwordInstallSource.h>
#import <ObjCSword/SwordModule.h>

@class ModuleListObject;

@protocol ModuleListViewControllerDelegate <NSObject>
@optional
- (void)unregister:(ModuleListObject *)modObj;
- (void)registerForInstall:(ModuleListObject *)modObj;
- (void)registerForRemove:(ModuleListObject *)modObj;
- (void)registerForUpdate:(ModuleListObject *)modObj;
@end

@interface ModuleListViewController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate, NSMenuItemValidation> {
    
    IBOutlet NSOutlineView *moduleOutlineView;
    IBOutlet NSSearchField *searchTextField;
    
    IBOutlet NSMenu *moduleMenu;
    IBOutlet NSPopUpButton *languagesButton;
}

@property (readwrite) NSString *langFilter;
@property (strong, readwrite) NSArray *installSources;
@property (strong, readwrite) IBOutlet id<ModuleListViewControllerDelegate> delegate;

- (void)refreshModulesList;
- (void)refreshSwordManager;

- (IBAction)search:(id)sender;
- (IBAction)languageFilter:(id)sender;

- (IBAction)noneTask:(id)sender;
- (IBAction)installModule:(id)sender;
- (IBAction)removeModule:(id)sender;
- (IBAction)updateModule:(id)sender;

@end
