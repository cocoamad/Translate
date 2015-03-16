//
//  RecentListViewController.m
//  Ever
//
//  Created by Penny on 13-4-27.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import "RecentListViewController.h"
#import "LPCommon.h"

@interface RecentListViewController ()

@end

@implementation RecentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.contentView.delegate = self;
     [self.contentView setDataSource: [[LPCommon shareCommon] allLanguages]];
}

- (void)lanChoose:(ContainerView *)view LanObject:(LPLanaguageObject *)obj;
{
    if (_selectedLanBlock) {
        _selectedLanBlock(obj);
    }
}

- (void)dealloc
{
    
}

@end

@implementation ContainerView

- (void)awakeFromNib
{
    _mouseDownIndex = -1;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint point = [theEvent locationInWindow];
    point = [self convertPoint: point fromView: nil];
    for (LanItem *item in _items) {
        if (CGRectContainsPoint(item.frame, point)) {
            _mouseDownIndex = item.index;
            break;
        }
    }
    [super mouseDown: theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint point = [theEvent locationInWindow];
    point = [self convertPoint: point fromView: nil];
    for (LanItem *item in _items) {
        if (CGRectContainsPoint(item.frame, point)) {
            if (item.index == _mouseDownIndex) {
                if (_delegate && [_delegate respondsToSelector: @selector(lanChoose:LanObject:)]) {
                    [_delegate lanChoose: self LanObject: item.lanObj];
                    break;
                }
            }
        }
    }
}

- (void)setDataSource:(NSArray *)dataSource
{
    if (![_dataSource isEqualTo: dataSource]) {
        _dataSource = dataSource;
        [self layoutItem];
    }
}

- (void)layoutItem
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    } else
        [_items removeAllObjects];
    
    for (NSInteger i = _dataSource.count - 1; i >= 0; i--) {
        LPLanaguageObject *object = _dataSource[i];
        LanItem *item = [[LanItem alloc] init];
        item.lanObj = object;
        item.index = i;
        item.frame = NSMakeRect(ContentMargin.left + (i % 3) * ItemSize.width, ContentMargin.top + (i / 3) * ItemSize.height, ItemSize.width, ItemSize.height);
        [_items addObject: item];
    }
    
    [self setNeedsDisplay: YES];

}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    for (LanItem *item in _items) {
        [item draw: ctx];
    }
}
@end

@implementation LanItem

- (void)draw:(CGContextRef)ctx;
{
    if (self.lanObj.name.length) {
        NSSize fontSize = [self.lanObj.name sizeWithAttributes: @{NSFontAttributeName : [NSFont systemFontOfSize: 12]}];
        CGFloat offy = (self.frame.size.height - fontSize.height) * .5;
        [self.lanObj.name drawInRect: NSMakeRect(NSMinX(self.frame), offy + NSMinY(self.frame), fontSize.width, fontSize.height)
            withAttributes: @{NSFontAttributeName : [NSFont systemFontOfSize: 12], NSForegroundColorAttributeName : [NSColor whiteColor]}];
    }
}

@end

