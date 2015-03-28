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
@end
