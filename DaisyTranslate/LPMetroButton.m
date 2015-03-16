//
//  LPMetroButton.m
//  Ever
//
//  Created by Penny on 13-6-7.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import "LPMetroButton.h"
#import "LPCommon.h"

@interface LPMetroButton()
@property (nonatomic, retain) NSTrackingArea *area ;
@end

@implementation LPMetroButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _titleFont = [NSFont systemFontOfSize: 12];
        _mouseDownColor = _titleColor = [NSColor whiteColor];
        _area = [[NSTrackingArea alloc] initWithRect: self.bounds
                                                            options: NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved
                                                              owner: self userInfo: nil];
        _radius = -1;
        [self addTrackingArea: _area];
    }
    
    return self;
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame: frameRect];
    
    [self removeTrackingArea: self.area];
    self.area = [[NSTrackingArea alloc] initWithRect: self.bounds
                                                        options: NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved
                                                          owner: self userInfo: nil];
    
    [self addTrackingArea: _area];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

- (void)setRadius:(NSInteger)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)addTarget:(id)target Action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    bMouseDown = YES;
    [self setNeedsDisplay: YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint  point = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    if (CGRectContainsPoint(self.bounds, point)) {
        if (_target && [_target respondsToSelector: _action] && bMouseDown) {
            [_target performSelector: _action withObject: self];
        }
    }
    bMouseDown = NO;
    [self setNeedsDisplay: YES];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    bMouseIn = YES;
    [self setNeedsDisplay: YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    bMouseIn = NO;
    bMouseDown = NO;
    [self setNeedsDisplay: YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    CGRect bound = self.bounds;
    
    if (_backgroundColor) {
        if (_radius > 0) {
            CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
            CGPathRef path = createRoundRectPathInRect(self.bounds, _radius);
            CGContextSetFillColorWithColor(ctx, _backgroundColor.CGColor);
            CGContextAddPath(ctx, path);
            CGContextFillPath(ctx);
            CGPathRelease(path);
        } else {
            [_backgroundColor setFill];
            NSRectFill(bound);
        }
    }
    
    if (bMouseDown) {
        if (_mouseDownColor) {
            if (_radius > 0) {
                CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
                CGPathRef path = createRoundRectPathInRect(self.bounds, _radius);
                CGContextSetFillColorWithColor(ctx, _mouseDownColor.CGColor);
                CGContextAddPath(ctx, path);
                CGContextFillPath(ctx);
                CGPathRelease(path);
            } else {
                [_mouseDownColor setFill];
                NSRectFill(bound);
            }
        }
        
    } else if (bMouseIn) {
        if (_hoverColor) {
            if (_radius > 0) {
                CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
                CGPathRef path = createRoundRectPathInRect(self.bounds, _radius);
                CGContextSetFillColorWithColor(ctx, _hoverColor.CGColor);
                CGContextAddPath(ctx, path);
                CGContextFillPath(ctx);
                CGPathRelease(path);
            } else {
                [_hoverColor setFill];
                NSRectFill(bound);
            }
        }
    }
    
    if (_title) {
        NSSize fontSize = [_title sizeWithAttributes: @{NSFontAttributeName : _titleFont}];
        CGFloat offx = (bound.size.width - fontSize.width) * .5;
        CGFloat offy = (bound.size.height - fontSize.height) * .5;
        NSColor *titleColor = _titleColor;
        if (bMouseDown && _mouseDownTitleColor) {
            titleColor = _mouseDownTitleColor;
        }
        [_title drawInRect: NSMakeRect(offx, offy, fontSize.width, fontSize.height)
            withAttributes: @{NSFontAttributeName : _titleFont, NSForegroundColorAttributeName : titleColor}];
    }
    
    
}

@end


