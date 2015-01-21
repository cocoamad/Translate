//
//  LPTranslateResultTableCellView.m
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPTranslateResultTableCellView.h"

@implementation LPTranslateResultTableCellView

- (void)awakeFromNib
{
    [self.resultTextView setBackgroundColor: [NSColor colorWithCalibratedRed: 44. / 255 green: 60. / 255 blue: 71. / 255 alpha: 1]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setResult:(LPTranslateResult *)result
{
    if (result && [_result isEqualTo: result]) {
        [self updateUI];
    }
}

- (void)updateUI
{
    
}

@end
