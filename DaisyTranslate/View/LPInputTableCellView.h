//
//  LPInputTableCellView.h
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/18/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LPInputTableCellView;

@protocol LPInputTableCellViewDelegate <NSObject>

- (void)footViewWillShow:(LPInputTableCellView *)view;
- (void)footViewWillHide:(LPInputTableCellView *)view;

@end

@interface LPInputTableCellView : NSView
@property (nonatomic, strong) NSTextView *inputTextView;

@property (assign) id <LPInputTableCellViewDelegate> delegate;
@end
