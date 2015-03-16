//
//  LPMetroButton.h
//  Ever
//
//  Created by Penny on 13-6-7.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPCommon.h"

@interface LPMetroButton : NSControl {
    
    BOOL bMouseIn;
    BOOL bMouseDown;
    
    id _target;
    SEL _action;
}
@property (nonatomic, strong) NSColor *backgroundColor;
@property (nonatomic, strong) NSColor *hoverColor;
@property (nonatomic, strong) NSColor *mouseDownColor;
@property (nonatomic, strong) NSColor *disableColor;

@property (nonatomic, strong) NSImage *image;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSFont *titleFont;
@property (nonatomic, strong) NSColor *titleColor;
@property (nonatomic, strong) NSColor *mouseDownTitleColor;


@property (nonatomic, weak) LPLanaguageObject *object;

- (void)addTarget:(id)target Action:(SEL)action;

@end
