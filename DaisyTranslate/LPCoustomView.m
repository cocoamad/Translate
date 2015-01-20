//
//  LPCoustomView.m
//  Ever
//
//  Created by Penny on 13-5-24.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import "LPCoustomView.h"

@implementation LPCoustomView

- (id)initWithFrame:(NSRect)frameRect DrawBackgroundBlock:(DrawBackgroundBlock)block
{
    if (self = [super initWithFrame: frameRect]) {
        self.drawBackgroundBlock = block;
    }
    return self;
}

- (void)setDrawBackgroundBlock:(DrawBackgroundBlock)drawBackgroundBlock
{
    _drawBackgroundBlock = [drawBackgroundBlock copy];
    [self setNeedsDisplay: YES];
}

- (void)dealloc
{
    self.drawBackgroundBlock = nil;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    CGContextSaveGState(ctx);
    if (_drawBackgroundBlock) {
        _drawBackgroundBlock(ctx);
    }

    CGContextRestoreGState(ctx);
}

@end
