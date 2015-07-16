//
//  AppDelegate.h
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPCoustomView.h"
#import "LPTranslateService.h"
#import "SRRecorderControl.h"
#import "PTHotKey.h"
#import "StatusBarView.h"
#import "INAppStoreWindow.h"
@interface MainWindow : NSWindow
@end

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, StatusBarViewDelegate, NSSoundDelegate>
{
    PTHotKey *_hotKey;
    NSMenu *_settingMenu;
}
@property (weak) IBOutlet INAppStoreWindow *window;
@property (assign) IBOutlet LPCoustomView *titleBarView;
@property (nonatomic, strong) LPTranslateService *service;
@property (nonatomic, assign) IBOutlet NSTableView *tableview;

@property (nonatomic, assign) IBOutlet NSWindow *preferenceWindow;
@property (nonatomic, strong) SRRecorderControl *hotKeyControl;
@property (nonatomic, strong) StatusBarView *statusBar;
@property (nonatomic, assign) IBOutlet NSMenuItem *showMainWindowItem;
@property (nonatomic ,assign) BOOL   hasActivePanel;

- (void)playSound:(NSString *)string to:(NSString *)to;
- (IBAction)openPerfrence:(id)sender;
- (IBAction)menuShowMainWindow:(id)sender;
@end

