//
//  LPInputTableCellView.m
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/18/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPInputTableCellView.h"
#import "NSTextView+Placeholder.h"

#define INPUT_EDGE_INSET NSEdgeInsetsMake(5, 2, 0, 7)



@interface LPInputTableCellView()
@property (nonatomic, assign) BOOL footViewHide;
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
        
        NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame: scrollViewRect];
        self.inputTextView = [[NSTextView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(scrollViewRect), NSHeight(scrollViewRect))];
        self.inputTextView.font = [NSFont systemFontOfSize: 16];
        [self.inputTextView setVerticallyResizable:YES];
        [self.inputTextView setHorizontallyResizable:NO];
        [self.inputTextView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [[self.inputTextView textContainer] setContainerSize: NSMakeSize(scrollViewRect.size.width, FLT_MAX)];
        [[self.inputTextView textContainer] setWidthTracksTextView:YES];
        [self.inputTextView setRichText: NO];
        [self.inputTextView setFocusRingType: NSFocusRingTypeNone];
        
        [scrollView setDocumentView: self.inputTextView];
        
        self.inputTextView.placeholderString = @"请输入要翻译的内容";
        [self addSubview: scrollView];
        _footViewHide = YES;
        
    }
    return self;
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
        } else {
            if (_delegate && [_delegate respondsToSelector: @selector(footViewWillHide:)]) {
                _footViewHide = YES;
                [_delegate footViewWillHide: self];
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(self.bounds);
}
@end
