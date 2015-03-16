//
//  RecentListViewController.h
//  Ever
//
//  Created by Penny on 13-4-27.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPCommon.h"

typedef BOOL (^keyDownEventBlock)(unsigned short keyCode);
typedef void (^SelectedLanBlock)(LPLanaguageObject * object);
typedef void (^SelectedRowAtIndexBlock)(NSInteger row);
#define KeyDown 125
#define KeyUp 126
#define KeyEnter 36
#define KeySpace 49
#define KeyESC 53

#define ContentMargin NSEdgeInsetsMake(10,10,10,10)
#define ItemSize      NSMakeSize(80,20)
@class ContainerView;
@interface RecentListViewController : NSViewController
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) IBOutlet ContainerView *contentView;
@end

@interface ContainerView : NSView {
    NSMutableArray *_items;
}
@property (nonatomic, strong) NSArray *dataSource;
@end

@interface LanItem : NSObject
@property (nonatomic, assign) NSRect frame;
@property (nonatomic, strong) LPLanaguageObject *lanObj;

- (void)draw:(CGContextRef)ctx;
@end