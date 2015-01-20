//
//  LPInputFootTableCellView.m
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPInputFootTableCellView.h"

@implementation LPInputFootTableCellView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame: frameRect]) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    CGContextSetFillColorWithColor(ctx, [NSColor colorWithCalibratedRed: 44. / 255 green: 60. / 255 blue: 71. / 255 alpha: 1].CGColor);
    CGContextFillRect(ctx, self.bounds);
}

@end
