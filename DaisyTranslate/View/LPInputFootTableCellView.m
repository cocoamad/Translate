//
//  LPInputFootTableCellView.m
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPInputFootTableCellView.h"

#define BUTTON_SIZE NSMakeSize(60, 22)

@implementation LPInputFootTableCellView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame: frameRect]) {
        LPMetroButton *btn = [[LPMetroButton alloc] initWithFrame: NSMakeRect(NSWidth(frameRect) - 80, (NSHeight(frameRect) - BUTTON_SIZE.height) * .5, BUTTON_SIZE.width, BUTTON_SIZE.height)];
        btn.backgroundColor = [NSColor colorWithCalibratedRed: 91. / 255 green: 124. / 255 blue: 157. / 255 alpha: 1];
        btn.mouseDownColor = [NSColor colorWithCalibratedRed: 174. / 255 green: 190. /255 blue: 206. / 255 alpha: 1];
        btn.title = @"翻译";
        btn.titleColor = [NSColor whiteColor];
        btn.titleFont = [NSFont systemFontOfSize: 11];
        
        [btn addTarget: self Action: @selector(translate:)];
        
        [self addSubview: btn];
    }
    return self;
}

- (void)translate:(id)sender
{
    if (_delegate && [_delegate respondsToSelector: @selector(translateClick:)]) {
        [_delegate translateClick: self];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    CGContextSetFillColorWithColor(ctx, [NSColor colorWithCalibratedRed: 44. / 255 green: 60. / 255 blue: 71. / 255 alpha: 1].CGColor);
    CGContextFillRect(ctx, self.bounds);
}

@end
