//
//  LPTranslateResultTableCellView.m
//  DaisyTranslate
//
//  Created by pennyli on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPTranslateResultTableCellView.h"
#import "LPCommon.h"
#import "AppDelegate.h"
#import "AppDelegate+Setting.h"

@implementation LPTranslateResultTableCellView

- (void)awakeFromNib
{
    [self.resultTextView setBackgroundColor: FootBarBackgroundColor];
    self.resultTextView.textColor = [NSColor whiteColor];
    self.resultTextView.font = [NSFont systemFontOfSize: 14];
}

- (void)setProgress:(CGFloat)precent
{
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [FootBarBackgroundColor setFill];
    NSRectFill(self.bounds);
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
    [[self.resultTextView enclosingScrollView] setFrame: NSMakeRect(ResultCellExtraInset.left, ResultCellExtraInset.bottom, NSWidth(self.frame) - ResultCellExtraInset.left - ResultCellExtraInset.right,  NSHeight(self.frame) - ResultCellExtraInset.top - ResultCellExtraInset.bottom)];
    
    [self.botView setFrame: NSMakeRect(0, 0, NSWidth(self.frame), ResultCellExtraInset.bottom)];
    
    NSMutableString *resultString = [NSMutableString new];
    for (LPResultData *data in _result.result) {
        NSString *string = data.dst;
        [resultString appendString: string];
        debug_log(@"%@", string);
        if (_result.means.symboles.count) {
            [resultString appendString: @"\n"];
            [resultString appendString: @"\n"];
        }
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
        
        if (symbole.symboleParts.count) {
            [resultString appendFormat: @"\n"];
        }
        
        NSInteger count = 0;
        for (LPSymbolePart *part in symbole.symboleParts) {
            if (part.part.length)
                [resultString appendFormat: @"%@  ", part.part];
            for (NSString *mean in part.means) {
                [resultString appendFormat: @"%@;", mean];
            }
            if (count++ != symbole.symboleParts.count - 1) {
                [resultString appendFormat: @"\n"];
            }
        }
    }
    
    [self.resultTextView setString: resultString];
    
    if ([(AppDelegate *)[NSApplication sharedApplication].delegate bSupportCopytoPBWhenTranslated]) {
        [self copyText: nil];
    }
}


- (IBAction)copyText:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    if (_result.result.count) {
        LPResultData *data = _result.result[0];
        [pb setString: data.dst forType: NSStringPboardType];
    }
}

- (IBAction)playSound:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    NSString *translateString = [[_result.result lastObject] dst];
    if (translateString.length) {
        [delegate playSound: translateString to: _result.to];
    }

}
@end
