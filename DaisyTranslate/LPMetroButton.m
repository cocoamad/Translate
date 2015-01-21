//
//  LPMetroButton.m
//  Ever
//
//  Created by Penny on 13-6-7.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import "LPMetroButton.h"

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
        _titleColor = [NSColor whiteColor];
        
        _area = [[NSTrackingArea alloc] initWithRect: self.bounds
                                                            options: NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved
                                                              owner: self userInfo: nil];
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
        [_backgroundColor setFill];
        NSRectFill(bound);
    }
    
    if (bMouseDown) {
        if (_mouseDownColor) {
            [_mouseDownColor setFill];
            NSRectFill(bound);
        }
    } else if (bMouseIn) {
        if (_hoverColor) {
            [_hoverColor setFill];
            NSRectFill(bound);
        }
    }
    
    if (_title) {
        NSSize fontSize = [_title sizeWithAttributes: @{NSFontAttributeName : _titleFont}];
        CGFloat offx = (bound.size.width - fontSize.width) * .5;
        CGFloat offy = (bound.size.height - fontSize.height) * .5;
        [_title drawInRect: NSMakeRect(offx, offy, fontSize.width, fontSize.height)
            withAttributes: @{NSFontAttributeName : _titleFont, NSForegroundColorAttributeName : _titleColor}];
    }
    
    
}

@end


