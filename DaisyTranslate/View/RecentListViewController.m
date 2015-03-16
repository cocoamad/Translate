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

- (void)setDataSource:(NSArray *)dataSource
{
    [self.contentView setDataSource: dataSource];
}

- (void)dealloc
{
    
}

@end

@implementation ContainerView



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
    
    NSInteger i = 0;
    for (LPLanaguageObject *object in _dataSource) {
        LanItem *item = [[LanItem alloc] init];
        item.lanObj = object;
        item.frame = NSMakeRect(ContentMargin.left + (i % 3) * ItemSize.width, ContentMargin.top + (i / 3) * ItemSize.height, ItemSize.width, ItemSize.height);
        i++;
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
            withAttributes: @{NSFontAttributeName : [NSFont systemFontOfSize: 12], NSForegroundColorAttributeName : [NSColor redColor]}];
    }
}

@end

