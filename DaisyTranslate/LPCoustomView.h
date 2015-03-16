//
//  LPCoustomView.h
//  Ever
//
//  Created by Penny on 13-5-24.
//  Copyright (c) 2013年 Penny. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^DrawBackgroundBlock)(CGContextRef ctx, NSRect rect);

@interface LPCoustomView : NSView
@property (nonatomic, copy) DrawBackgroundBlock drawBackgroundBlock;
@property (nonatomic, strong) NSColor *backgroundColor;
- (id)initWithFrame:(NSRect)frameRect DrawBackgroundBlock:(DrawBackgroundBlock)block;
@end
