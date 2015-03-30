//
//  AppDelegate+Setting.h
//  DaisyTranslate
//
//  Created by 鹏 李 on 3/8/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPCommon.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "AppDelegate.h"


@interface AppDelegate (Setting)
- (void)setRecordRecordController:(SRRecorderControl *)controller WithTag:(NSInteger)tag;
- (IBAction)changeShowStyle:(id)sender;

- (BOOL)bSupportCopytoPBWhenTranslated;
- (IBAction)autoLoginWhenStartup:(NSButton *)btn;

- (void)initSettingMenu;
- (void)showSettingMenu:(id)sender;
@end
