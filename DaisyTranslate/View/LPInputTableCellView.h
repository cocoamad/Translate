//
//  LPInputTableCellView.h
//  DaisyTranslate
//
//  Created by pennyli on 1/18/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPCommon.h"

@class LPInputTableCellView;

@protocol LPInputTableCellViewDelegate <NSObject>

- (void)footViewWillShow:(LPInputTableCellView *)view;
- (void)footViewWillHide:(LPInputTableCellView *)view;
- (void)inputTextViewContentChanged:(LPInputTableCellView *)view height:(CGFloat)height completeBlock:(InputCellHeightChangeCompleteBlock)block;
- (void)translate;
@end

@interface LPInputTableCellView : NSView
@property (nonatomic, strong) NSTextView *inputTextView;
@property (nonatomic, strong) NSButton *clearBtn;

@property (nonatomic, assign) NSInteger initHeight;
@property (nonatomic, assign) NSInteger lastHeight;

@property (assign) id <LPInputTableCellViewDelegate> delegate;
@end
