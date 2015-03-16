//
//  LPInputFootTableCellView.h
//  DaisyTranslate
//
//  Created by pennyli on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPMetroButton.h"
#import "LPCommon.h"
#import "INPopoverController.h"

@class  LPInputFootTableCellView;
@class  ProgressView;
@protocol LPInputFootTableCellViewDelegate <NSObject>

- (void)translateClick:(LPInputFootTableCellView *)view;
- (void)lanChooseClick:(LPInputFootTableCellView *)view lanBtn:(LPMetroButton *)btn;

@end

@interface LPInputFootTableCellView : NSView <INPopoverControllerDelegate>
@property (nonatomic, weak) id  <LPInputFootTableCellViewDelegate> delegate;
@property (nonatomic, strong) LPMetroButton *fromBtn;
@property (nonatomic, strong) LPMetroButton *toBtn;
@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) INPopoverController *lanPopover;

- (void)resetFromLanguage:(LPLanaguageObject *)from ToLanguage:(LPLanaguageObject *)to;
@end


@interface ProgressView : NSView
@property (nonatomic, assign) CGFloat progress;
@end