//
//  StatusBarView.h
//  iTips
//
//  Created by Penny on 12-9-22.
//  Copyright (c) 2012年 Penny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPCommon.h"

@protocol StatusBarViewDelegate <NSObject>
- (void)statusItemClick:(BOOL)isHilighted;
- (void)showPreference;
@end

@interface StatusBarView : NSView <NSMenuDelegate, NSWindowDelegate> {
    NSStatusItem    *statusItem;
    NSMenu          *statusMenu;
    
    CGImageRef      normalIcon;
    CGImageRef      hilightIcon;
    BOOL            isHiLight;

}
@property (nonatomic, weak) id <StatusBarViewDelegate>delegate;
- (NSRect)globalRect;
@end

