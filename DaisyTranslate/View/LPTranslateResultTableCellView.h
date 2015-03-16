//
//  LPTranslateResultTableCellView.h
//  DaisyTranslate
//
//  Created by pennyli on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPTranslateResult.h"
#import "LPCommon.h"

@interface LPTranslateResultTableCellView : NSView {
    
}
@property (nonatomic, assign) IBOutlet NSTextView *resultTextView;
@property (nonatomic, assign) IBOutlet NSView *botView;
@property (nonatomic, strong) LPTranslateResult *result;

- (IBAction)copyText:(id)sender;
- (IBAction)playSound:(id)sender;
@end