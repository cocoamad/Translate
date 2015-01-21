//
//  LPInputFootTableCellView.h
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPMetroButton.h"

@class  LPInputFootTableCellView;

@protocol LPInputFootTableCellViewDelegate <NSObject>

- (void)translateClick:(LPInputFootTableCellView *)view;

@end

@interface LPInputFootTableCellView : NSView
@property (nonatomic, weak) id  <LPInputFootTableCellViewDelegate> delegate;
@end
