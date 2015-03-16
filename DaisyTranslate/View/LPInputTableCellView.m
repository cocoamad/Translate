//
//  LPInputTableCellView.m
//  DaisyTranslate
//
//  Created by pennyli on 1/18/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPInputTableCellView.h"
#import "NSTextView+Placeholder.h"
#import "AppDelegate.h"

#define INPUT_EDGE_INSET NSEdgeInsetsMake(0, 8, 0, 6)
#define BOT_PADDING 10
@interface InputTextView : NSTextView

@end

@implementation InputTextView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame: frameRect]) {
        [super setTextContainerInset:NSMakeSize(.0f, BOT_PADDING)];
    }
    return self;
}

@end

@interface LPInputTableCellView() <NSTextViewDelegate>
@property (nonatomic, assign) BOOL footViewHide;
@property (nonatomic, strong) NSString *lastDetectString;
@end

@implementation LPInputTableCellView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame: frameRect]) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didChangeText:)
                                                     name: NSTextDidChangeNotification
                                                   object: nil];
        NSRect scrollViewRect = NSMakeRect(INPUT_EDGE_INSET.left, 0, NSWidth(frameRect) - INPUT_EDGE_INSET.left - INPUT_EDGE_INSET.right, NSHeight(frameRect) - INPUT_EDGE_INSET.top - INPUT_EDGE_INSET.bottom);
        
        self.initHeight = NSHeight(frameRect);
        
        NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame: scrollViewRect];
        [scrollView setHasVerticalScroller: YES];
        self.inputTextView = [[InputTextView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(scrollViewRect), NSHeight(scrollViewRect))];
        self.inputTextView.textColor = [NSColor colorWithCalibratedRed: 102. / 255 green: 102. / 255 blue: 102. / 255 alpha: 1];
        self.inputTextView.font = [NSFont systemFontOfSize: 16];
        [self.inputTextView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [[self.inputTextView textContainer] setContainerSize: NSMakeSize(scrollViewRect.size.width, FLT_MAX)];
        [[self.inputTextView textContainer] setWidthTracksTextView:YES];
        [self.inputTextView setRichText: NO];
        self.inputTextView.allowsUndo = YES;
        [self.inputTextView setFocusRingType: NSFocusRingTypeNone];
        self.inputTextView.delegate = self;
        [scrollView setDocumentView: self.inputTextView];
        
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        self.inputTextView.placeholderString = @"请输入要翻译的内容";
        [self addSubview: scrollView];
        
        _footViewHide = YES;
        
    }
    return self;
}

- (void)clearContent:(id)sender
{
    [self.inputTextView setString: @""];
    [_clearBtn setHidden: YES];
}

- (void)didChangeText:(NSNotification *)n
{
    NSTextView *textView = [n object];
    if ((textView = self.inputTextView)) {
        if (textView.string.length > 0) {
            if (_footViewHide) {
                if (_delegate && [_delegate respondsToSelector: @selector(footViewWillShow:)]) {
                    _footViewHide = NO;
                    [_delegate footViewWillShow: self];
                }
            }
            
            NSString *detectString = [textView.string substringWithRange: NSMakeRange(0, MIN(16, textView.string.length))];
            if (![self.lastDetectString isEqualToString: detectString]) {
                self.lastDetectString = detectString;
                AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
                [appDelegate.service translateStringDetect: self.lastDetectString];
            }
          
            
            NSSize size = [[textView layoutManager] usedRectForTextContainer:[textView textContainer]].size;
            CGFloat height = size.height + 2 * BOT_PADDING;
            if (_delegate && [_delegate respondsToSelector: @selector(inputTextViewContentChanged:height:completeBlock:)]) {
                
                [_delegate inputTextViewContentChanged: self height: height completeBlock:^(BOOL changed) {
                }];

            }
            
        } else {
            if (_delegate && [_delegate respondsToSelector: @selector(footViewWillHide:)]) {
                [_clearBtn setHidden: YES];
            }
        }
        

    }
}

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if ([NSStringFromSelector(commandSelector) isEqualToString: @"insertNewline:"]) {
        if (self.inputTextView.string.length &&  _delegate && [_delegate respondsToSelector: @selector(translate)]) {
            [_delegate translate];
        }
        return YES;
    }
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(self.bounds);
}
@end
