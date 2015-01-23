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
    self.resultTextView.textColor = [NSColor whiteColor];
    self.resultTextView.font = [NSFont systemFontOfSize: 12];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setResult:(LPTranslateResult *)result
{
    if (result && ![_result isEqualTo: result]) {
        _result = result;
        [self updateUI];
    }
}

- (void)updateUI
{
    NSMutableString *resultString = [NSMutableString new];
    for (LPResultData *data in _result.result) {
        NSString *string = data.dst;
        [resultString appendString: string];
        [resultString appendString: @"\n"];
        [resultString appendString: @"\n"];
    }
    
    for (LPSimpleMeansSymbole *symbole in _result.means.symboles) {
        NSString *am = symbole.ph_am;
        NSString *en = symbole.ph_en;
        if (am.length) {
            [resultString appendFormat: @"[美][%@]  ", am];
        }
        if (en.length) {
            [resultString appendFormat: @"[英][%@]", en];
        }
        [resultString appendFormat: @"\n"];
        
        for (LPSymbolePart *part in symbole.symboleParts) {
            if (part.part.length)
                [resultString appendFormat: @"%@  ", part.part];
            for (NSString *mean in part.means) {
                [resultString appendFormat: @"%@;", mean];
            }
            [resultString appendFormat: @"\n"];
        }
    }
    
    [self.resultTextView setString: resultString];
}

@end
