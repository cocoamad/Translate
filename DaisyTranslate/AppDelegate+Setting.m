//
//  AppDelegate+Setting.m
//  DaisyTranslate
//
//  Created by 鹏 李 on 3/8/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "AppDelegate+Setting.h"
#import "AppDelegate.h"
#import <ServiceManagement/ServiceManagement.h>

#define helperAppBundleIdentifier @"com.cocoamad.aTranslatorHelperApp"
#define terminateNotification @"TERMINATEHELPER"

@implementation AppDelegate (Setting)

#pragma mark - HotKeyControl Delegate
- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason
{
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
{
    PTHotKey *hotKey = nil;
    NSString *identify = @"";
    if (aRecorder.tag == 0) {
        hotKey = _hotKey;
        identify = @"openTranslateWindow";
    }
    
    if (newKeyCombo.code == -1 && newKeyCombo.flags == 0) {
        [hotKey setKeyCombo: [PTKeyCombo clearKeyCombo]];
        [[PTHotKeyCenter sharedCenter] updateHotKey: hotKey];
    } else {
        [self toggleHotKey: newKeyCombo PTHotKey: hotKey Target: self Action: @selector(hotKeyResponse:) Identifier: identify];
    }
    [self saveHotkey: newKeyCombo Tag: aRecorder.tag];
}


- (void)saveHotkey:(KeyCombo)keyCombo Tag:(NSInteger)tag
{
    NSString *key = @"";
    if (tag == 0) {
        key = @"openTranslateWindow";
    }
    
    NSInteger flags = keyCombo.flags;
    NSInteger code = keyCombo.code;
    NSDictionary *dict = @{@"flag" : [NSNumber numberWithInteger: flags], @"code" : [NSNumber numberWithInteger: code]};
    [[NSUserDefaults standardUserDefaults] setValue: dict forKey: key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark PTHotKey Action
- (void)toggleHotKey:(KeyCombo)keyCombo PTHotKey:(PTHotKey *)hotKey Target:(id)target Action:(SEL)sel Identifier:(NSString*)identifier
{
    if (hotKey != nil)
    {
        [[PTHotKeyCenter sharedCenter] unregisterHotKey: hotKey];
        hotKey = nil;
    }
    
    if (keyCombo.code != 0 && keyCombo.flags != 0) {
        hotKey = [[PTHotKey alloc] init];
        [hotKey setKeyCombo: [PTKeyCombo keyComboWithKeyCode: (int)keyCombo.code
                                                   modifiers: (int)SRCocoaToCarbonFlags(keyCombo.flags)]];
        
        [hotKey setName: identifier];
        [hotKey setTarget: target];
        [hotKey setAction: sel];
        [[PTHotKeyCenter sharedCenter] registerHotKey: hotKey];
    }
}

- (void)setRecordRecordController:(SRRecorderControl *)controller WithTag:(NSInteger)tag
{
    controller.delegate = self;
    controller.tag = tag;
    
    if (tag == 0) {
        NSDictionary *comboDict = [[NSUserDefaults standardUserDefaults] objectForKey: @"openTranslateWindow"];
        if (comboDict) {
            KeyCombo combo = SRMakeKeyCombo([comboDict[@"code"] integerValue], [comboDict[@"flag"] integerValue]);
            [controller setKeyCombo: combo];
            [self toggleHotKey: combo PTHotKey: _hotKey Target: self
                        Action: @selector(hotKeyResponse:)
                    Identifier: @"open"];
        }
        
    }
}

- (void)hotKeyResponse:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
    [self.window makeKeyAndOrderFront: nil];
    
}

- (IBAction)changeShowStyle:(NSPopUpButton *)sender;
{
    NSInteger index = [sender indexOfSelectedItem];
    if (index == 0) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
        [NSApp setPresentationOptions:NSApplicationPresentationDefault];
        [NSMenu setMenuBarVisible:NO];
        [NSMenu setMenuBarVisible:YES];
        
        self.statusBar = [[StatusBarView alloc] initWithFrame: NSMakeRect(0, 0, 24, 18)];
        self.statusBar.delegate = self;
        
        [self.window setStyleMask: NSBorderlessWindowMask];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self statusItemClick: YES];
        });

        
    } else if (index == 1) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp setPresentationOptions:NSApplicationPresentationDefault];
        [NSMenu setMenuBarVisible:NO];
        [NSMenu setMenuBarVisible:YES];
        
        [self.statusBar removeFromSuperview];
        self.statusBar = nil;
        
        [self.window setStyleMask: NSTitledWindowMask | NSClosableWindowMask];
        [self.window setTitle: @"aTranslator"];
    }
}

- (BOOL)bSupportCopytoPBWhenTranslated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: kUserDefault_AutoCopyToPasteboard];
}

- (IBAction)autoLoginWhenStartup:(NSButton *)btn;
{
    BOOL startup = [[NSUserDefaults standardUserDefaults] boolForKey: kUserDefault_AutoLoginWhenStartup];
    if (startup) {
        // Turn on launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)helperAppBundleIdentifier, YES)) {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"An error ocurred";
            alert.informativeText = @"Couldn't add Helper App to launch at login item list.";
            [alert addButtonWithTitle: @"OK"];
            [alert runModal];
        }
    } else {
        // Turn off launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)helperAppBundleIdentifier, NO)) {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"An error ocurred";
            alert.informativeText = @"Couldn't remove Helper App from launch at login item list.";
            [alert addButtonWithTitle: @"OK"];
            [alert runModal];
        }
    }
}

#pragma makr -
- (void)initSettingMenu;
{
    _settingMenu = [[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: @"menu"];
    
    NSMenuItem *newItem = [[NSMenuItem allocWithZone: [NSMenu menuZone]] initWithTitle: NSLocalizedString(@"Preferences", nil) action: @selector(showPreference) keyEquivalent: @","];
    [newItem setTarget: self];
    [newItem setEnabled: YES];
    [_settingMenu addItem: newItem];
    
    [_settingMenu addItem: [NSMenuItem separatorItem]];
    
    newItem = [[NSMenuItem allocWithZone: [NSMenu menuZone]] initWithTitle: NSLocalizedString(@"Support", nil) action: @selector(showSupport) keyEquivalent: @""];
    [newItem setTarget: self];
    [newItem setEnabled: YES];
    [_settingMenu addItem: newItem];
    
    [_settingMenu addItem: [NSMenuItem separatorItem]];
    
    newItem = [[NSMenuItem allocWithZone: [NSMenu menuZone]] initWithTitle: NSLocalizedString(@"Quit aTranslator", nil) action: @selector(quit) keyEquivalent: @"q"];
    [newItem setTarget: self];
    [newItem setEnabled: YES];
    [_settingMenu addItem: newItem];
}

- (void)showSettingMenu:(id)sender
{
    [_settingMenu popUpMenuPositioningItem: nil atLocation: [sender frame].origin inView: self.window.titleBarView];
}

- (void)showSupport
{
    NSString *shortVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"]];
    NSString *bundleVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    NSString *version = [NSString stringWithFormat: @"aTranslator V%@(%@)", bundleVersion,shortVersion];
    
    NSString *subject = [NSString stringWithFormat: @"%@ Bug Report & Feature Requests", version];
    NSMutableString *body = [NSMutableString stringWithString:@"If you have any new and cool features in your mind, please feel free drop us a line, we'll try our best to make aTranslator Better!\n\n \
Please send us the following information:\n \
- What you were doing when the issue happened\n \
- Whether you were able to replicate it\n \
- Include any screenshots that might help us\n\n\n\n"];
    [body replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [body length])];
    NSString *address = @"cocoamad@gmail.com";
    NSAppleScript *mailScript;
    NSString *scriptString= [NSString stringWithFormat:
                             @"tell application \"Mail\" \n  set theNewMessage to make new outgoing message with properties {subject:\"%@\", content:\"%@\", visible:true} \n  \
                             tell theNewMessage \n    \
                             set visibile to true\n    \
                             make new to recipient at end of to recipients with properties {address:\"%@\"}\n   \
                             end tell\n\
                             activate\n  \
                             end tell",subject, body, address];
    
    
    NSDictionary *error = nil;
    mailScript = [[NSAppleScript alloc] initWithSource:scriptString];
    [mailScript executeAndReturnError: &error];
    if (error) {
        NSLog(@"%@", [error description]);
    }
}

- (void)quit
{
    [[NSApplication sharedApplication] terminate: nil];
}
@end
