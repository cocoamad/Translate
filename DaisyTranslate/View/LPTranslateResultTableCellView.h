//
//  LPTranslateResultTableCellView.h
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPTranslateResult.h"

@interface LPTranslateResultTableCellView : NSView {
    
}
@property (nonatomic, assign) IBOutlet NSTextView *resultTextView;
@property (nonatomic, strong) LPTranslateResult *result;
@end
