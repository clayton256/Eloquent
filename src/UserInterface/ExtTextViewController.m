//
//  ExtTextViewController.m
//  Eloquent
//
//  Created by Manfred Bergmann on 15.06.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ExtTextViewController.h"
#import "MouseTrackingScrollView.h"
#import "MBPreferenceController.h"
#import "globals.h"
#import "NSUserDefaults+Additions.h"
#import "MBTextView.h"

@interface ExtTextViewController ()

@end

@implementation ExtTextViewController

- (id)init {
    self = [self initWithDelegate:nil];
    
    return self;
}

- (id)initWithDelegate:(id<ExtTextViewDelegate>)aDelegate {
    self = [super init];
    if(self) {
        CocoLog(LEVEL_DEBUG, @"loading nib");
        
        // init values
        myIsViewLoaded = NO;
        self.delegate = aDelegate;

        // load nib
        BOOL stat = [[NSBundle mainBundle] loadNibNamed:EXTTEXTVIEW_NIBNAME owner:self topLevelObjects:nil];
        if(!stat) {
            CocoLog(LEVEL_ERR, @"unable to load nib!");
        }
    }
    
    return self;    
}

- (void)awakeFromNib {
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithCapacity:3];
    linkAttributes[NSUnderlineStyleAttributeName] = [UserDefaults objectForKey:DefaultsLinkUnderlineAttribute];
    linkAttributes[NSForegroundColorAttributeName] = [UserDefaults colorForKey:DefaultsLinkForegroundColor];
    linkAttributes[NSCursorAttributeName] = [NSCursor pointingHandCursor];
    [textView setLinkTextAttributes:linkAttributes];

    [textView setBackgroundColor:[UserDefaults colorForKey:DefaultsTextBackgroundColor]];

    NSMutableDictionary *selectionAttributes = [[textView selectedTextAttributes] mutableCopy];
    selectionAttributes[NSBackgroundColorAttributeName] = [UserDefaults colorForKey:DefaultsTextHighlightColor];
    [textView setSelectedTextAttributes:selectionAttributes];
    
    [textView setString:@""];
    scrollView.delegate = self;
    
    [textView setHorizontallyResizable:YES];
    [[textView textContainer] setWidthTracksTextView:YES];
    NSSize margins = NSMakeSize([[UserDefaults objectForKey:DefaultsTextContainerVerticalMargins] floatValue], 
                                [[UserDefaults objectForKey:DefaultsTextContainerHorizontalMargins] floatValue]);
    [textView setTextContainerInset:margins];
    [[NSUserDefaults standardUserDefaults] addObserver:self 
                                            forKeyPath:DefaultsTextContainerVerticalMargins
                                               options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self 
                                            forKeyPath:DefaultsTextContainerHorizontalMargins
                                               options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self 
                                            forKeyPath:DefaultsTextBackgroundColor
                                               options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self 
                                            forKeyPath:DefaultsTextHighlightColor
                                               options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self 
                                            forKeyPath:DefaultsLinkForegroundColor
                                               options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollViewFrameDidChange:)
                                                 name:NSViewFrameDidChangeNotification
                                               object:scrollView];
    
    [scrollView setPostsFrameChangedNotifications:YES];    
    [scrollView updateMouseTracking];

    myIsViewLoaded = YES;
    [self reportLoadingComplete];
}

/** pass though to delegate */
- (IBAction)saveDocument:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(saveDocument:)]) {
        [self.delegate saveDocument:sender];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// check for keyPath
	if([keyPath isEqualToString:DefaultsTextContainerVerticalMargins]) {
        NSSize margins = NSMakeSize([[UserDefaults objectForKey:DefaultsTextContainerVerticalMargins] floatValue], 
                                    [[UserDefaults objectForKey:DefaultsTextContainerHorizontalMargins] floatValue]);
        [textView setTextContainerInset:margins];
	} else if([keyPath isEqualToString:DefaultsTextContainerHorizontalMargins]) {
        NSSize margins = NSMakeSize([[UserDefaults objectForKey:DefaultsTextContainerVerticalMargins] floatValue], 
                                    [[UserDefaults objectForKey:DefaultsTextContainerHorizontalMargins] floatValue]);
        [textView setTextContainerInset:margins];
	} else if([keyPath isEqualToString:DefaultsTextBackgroundColor]) {
        [textView setBackgroundColor:[UserDefaults colorForKey:DefaultsTextBackgroundColor]];        
	} else if([keyPath isEqualToString:DefaultsTextHighlightColor]) {
        NSMutableDictionary *selectionAttributes = [[textView selectedTextAttributes] mutableCopy];
        selectionAttributes[NSBackgroundColorAttributeName] = [UserDefaults colorForKey:DefaultsTextHighlightColor];
        [textView setSelectedTextAttributes:selectionAttributes];
	} else if([keyPath isEqualToString:DefaultsLinkForegroundColor]) {
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionaryWithCapacity:3];
        linkAttributes[NSUnderlineStyleAttributeName] = [UserDefaults objectForKey:DefaultsLinkUnderlineAttribute];
        linkAttributes[NSForegroundColorAttributeName] = [UserDefaults colorForKey:DefaultsLinkForegroundColor];
        linkAttributes[NSCursorAttributeName] = [NSCursor pointingHandCursor];
        [textView setLinkTextAttributes:linkAttributes];
	}
}

#pragma mark - TextContentProviding

- (MBTextView *)textView {
    return textView;
}

- (MouseTrackingScrollView *)scrollView {
    return scrollView;
}

- (void)setAttributedString:(NSAttributedString *)aString {
    [[textView textStorage] setAttributedString:aString];    
}

- (void)setString:(NSString *)aString {
    [textView setString:aString];
}

- (void)textChanged:(NSNotification *)aNotification {
    if(self.delegate && [self.delegate respondsToSelector:@selector(textChanged:)]) {
        [self.delegate textChanged:aNotification];
    }
}

- (void)scrollToTop {
    [textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

#pragma mark - MBTextView delegates

- (NSMenu *)menuForEvent:(NSEvent *)event {
    if(self.delegate && [self.delegate respondsToSelector:@selector(menuForEvent:)]) {
        return [self.delegate menuForEvent:event];
    }
    return nil;
}

#pragma mark - NSTextView delegates

- (NSString *)textView:(NSTextView *)aTextView willDisplayToolTip:(NSString *)tooltip forCharacterAtIndex:(NSUInteger)characterIndex {
    NSURL *url = [NSURL URLWithString:[tooltip stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    if(!url) {
        CocoLog(LEVEL_WARN, @"no URL: %@\n", tooltip);
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(processPreviewDisplay:)]) {
            NSString *result = [self.delegate processPreviewDisplay:url];
            return result;
        }
    }
    
    return @"";
}

- (BOOL)textView:(NSTextView *)aTextView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if(self.delegate && [self.delegate respondsToSelector:@selector(linkClicked:)]) {
        [self.delegate linkClicked:link];
    }
    return YES;
}

- (void)textView:(NSTextView *)aTextView doubleClickedOnCell:(id < NSTextAttachmentCell >)cell inRect:(NSRect)cellFrame atIndex:(NSUInteger)charIndex {
}

#pragma mark - mouse tracking protocol

- (void)mouseEnteredView:(NSView *)theView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(mouseEnteredView:)]) {
        [self.delegate mouseEnteredView:[self view]];
    }
}

- (void)mouseExitedView:(NSView *)theView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(mouseExitedView:)]) {
        [self.delegate mouseExitedView:[self view]];
    }
}

- (void)scrollViewFrameDidChange:(NSNotification *)n {
    [scrollView updateMouseTracking];
}

@end
