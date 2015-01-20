//
//  AppDelegate.m
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import "AppDelegate.h"
#import "LPTranslateService.h"
#import "LPCommonDefine.h"
#import "INAppStoreWindow.h"
#import "LPInputTableCellView.h"
#import "LPInputFootTableCellView.h"

typedef enum {
    kRowInput = 0,
    kRowFoot,
    kRowResult
} ROW_TYPE;

#define InPutCellHeight 156
#define InPutFootCellHeight 37

typedef void (^WindowAnimationCompleteBlock)(void);

@interface AppDelegate () <LPInputTableCellViewDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, assign) NSInteger numberOfRow;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _numberOfRow = 1;
    [self.tableview setSelectionHighlightStyle: NSTableViewSelectionHighlightStyleNone];
//    self.window.titleBarHeight = 25;
//    self.window.title = @"aTranslator";
//    self.window.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect,
//                                         CGRectEdge edge, CGPathRef clippingPath)
//    {
//        CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
//        CGContextSetFillColorWithColor(ctx, [NSColor colorWithCalibratedRed: 45. / 255 green: 48. / 255 blue: 50. / 255 alpha: 1].CGColor);
//        CGContextAddPath(ctx, clippingPath);
//        CGContextFillPath(ctx);
//        
//
//        NSSize size = [NSLocalizedString(@"aTranslator", nil) sizeWithAttributes: @{NSFontAttributeName : [NSFont systemFontOfSize: 12]}];
//
//        CGRect titleRect = CGRectMake((drawingRect.size.width - size.width) * .5,
//                                      (drawingRect.size.height - size.height) * .5, size.width, size.height);
//        [NSLocalizedString(@"aTranslator", nil) drawInRect: titleRect withAttributes:
//         @{NSFontAttributeName : [NSFont systemFontOfSize: 12],
//           NSForegroundColorAttributeName : [NSColor whiteColor]}];
//    };
    
    [self.tableview reloadData];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7);
{
    if (row == kRowInput) {
        LPInputTableCellView *cell = [[LPInputTableCellView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(tableView.frame), [self heightOfRow: row])];

        cell.delegate = self;
        [self.window makeFirstResponder: cell.inputTextView];
        
        return cell;
    } else if (row == kRowFoot) {
        LPInputFootTableCellView *cell = [[LPInputFootTableCellView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(tableView.frame), [self heightOfRow: row])];
        return cell;
    } else if (row == kRowResult) {
        
    }
    return nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _numberOfRow;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return [self heightOfRow: row];
}

- (CGFloat)heightOfRow:(NSInteger)rowIndex
{
    if (rowIndex == kRowInput) {
        return InPutCellHeight;
    } else if (rowIndex == kRowFoot) {
        return InPutFootCellHeight;
    } else if (rowIndex == kRowResult) {
        return 80;
    }
    return 30;
}

- (CGFloat)heightOfTableView:(NSInteger)rowNumber
{
    if (rowNumber == 1) {
        return InPutCellHeight;
    } else {
        return InPutCellHeight + InPutFootCellHeight;
    }
}

- (void)footViewWillShow:(LPInputTableCellView *)view
{
    [_tableview insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: 1] withAnimation: NSTableViewAnimationEffectNone];
    _numberOfRow = 2;
    
    [self doWindowAniamtion: 2 completeBlock:^{
        
    }];
}

- (void)footViewWillHide:(LPInputTableCellView *)view
{
    [self doWindowAniamtion: 1 completeBlock:^{
        [_tableview removeRowsAtIndexes: [NSIndexSet indexSetWithIndex: 1] withAnimation: NSTableViewAnimationEffectNone];
        _numberOfRow = 1;
    }];
}


- (void)doWindowAniamtion:(NSInteger)rowNumber completeBlock:(WindowAnimationCompleteBlock)block
{
    NSRect windowRect = self.window.frame;
    CGFloat offy = [self heightOfTableView: rowNumber] + 22 - NSHeight(windowRect);
    windowRect.size.height += offy;
    windowRect.origin.y -= offy;
    [[NSAnimationContext currentContext] setDuration: .17];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [[self.window animator] setFrame: windowRect display: NO];
    } completionHandler:^{
        block();
    }];
}

//- (void)didChangeText:(NSNotification *)notification;
//{
//    NSTextView *textView = [notification object];
//    if ((textView = self.inputTextView)) {
//        [self handleTextChangedAnimaiton: textView.string.length > 0];
//    }
//    
//}
//
//- (void)handleTextChangedAnimaiton:(BOOL)hasContent
//{
//    if (hasContent) {
//        if (!self.footView.superview) {
//            NSRect footViewFrame = self.footView.frame;
//            NSRect windowFrame = self.window.frame;
//            windowFrame.origin.y -= NSHeight(footViewFrame);
//            windowFrame.size.height += NSHeight(footViewFrame);
//            
//            footViewFrame.origin.x = 0;
//            footViewFrame.origin.y = -NSHeight(footViewFrame);
//            footViewFrame.size.width = NSWidth(windowFrame);
//            
//            [self.footView setFrame: footViewFrame];
//            [self.window.contentView addSubview: self.footView];
//            
//            [[NSAnimationContext currentContext] setDuration: WindowAniamtionDuration];
//            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//                [[self.window animator] setFrame: windowFrame display: YES];
//                [[self.footView animator] setAlphaValue: 1.0f];
//            } completionHandler:^{
//                [self.footView setFrameOrigin: NSMakePoint(0, 0)];
//                [self.inputTextView setFrameOrigin:NSMakePoint(NSMinX(self.inputTextView.frame), NSMaxY(self.footView.frame))];
//            }];
//        }
//    } else {
//        NSRect windowFrame = self.window.frame;
//        NSRect footViewFrame = self.footView.frame;
//        windowFrame.origin.y += NSHeight(footViewFrame);
//        windowFrame.size.height -= NSHeight(footViewFrame);
//        
//        [[NSAnimationContext currentContext] setDuration: WindowAniamtionDuration];
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            [[self.window animator] setFrame: windowFrame display: YES];
//        } completionHandler:^{
//            [self.footView removeFromSuperview];
//            [self.inputTextView setFrameOrigin: NSMakePoint(0, 0)];
//        }];
//    }
//}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (!flag){
        [_window makeKeyAndOrderFront: nil];
    }
    
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//#pragma mark Action
//
- (IBAction)translate:(id)sender
{
//    NSString *translateString = self.translateField.stringValue;
//    if (translateString.length) {
//        NSString *from =  [self.languageDict objectForKey: [[self.fromLanBtn selectedItem] title]];
//        NSString *to = [self.languageDict objectForKey: [[self.toLanBtn selectedItem] title]];
//        [self.service translateString: translateString from: from to: to];
//    }
}
//
//- (IBAction)playSound:(id)sender
//{
//    NSString *translateString = self.translateField.stringValue;
//    if (translateString.length) {
//        NSString *from =  [self.languageDict objectForKey: [[self.fromLanBtn selectedItem] title]];
//        [self.service translateString2voice: translateString from: from speed: 2];
//    }
//}
//
//#pragma mark Translate Service Delegate
//
//- (void)translateDidFinished:(LPTranslateResult *)result
//{
//    if (result) {
//        NSMutableString *resultString = [NSMutableString new];
//        
//        for (LPResultData *data in result.result) {
//            NSString *string = data.dst;
//            [resultString appendString: string];
//            [resultString appendString: @"\n"];
//        }
//        
//        for (LPSimpleMeansSymbole *symbole in result.means.symboles) {
//            NSString *am = symbole.ph_am;
//            NSString *en = symbole.ph_en;
//            if (am.length) {
//                [resultString appendFormat: @"[美][%@]  ", am];
//            }
//            if (en.length) {
//                [resultString appendFormat: @"[英][%@]", en];
//            }
//            [resultString appendFormat: @"\n"];
//            
//            for (LPSymbolePart *part in symbole.symboleParts) {
//                if (part.part.length)
//                    [resultString appendFormat: @"%@  ", part.part];
//                for (NSString *mean in part.means) {
//                    [resultString appendFormat: @"%@;", mean];
//                }
//                [resultString appendFormat: @"\n"];
//            }
//        }
//        NSInteger index = 1;
//        for (LPResultLiju *liju in result.lijus) {
//            [resultString appendFormat: @"%ld.  %@", index++,liju.firstLijuStr];
//            [resultString appendString: @"\n"];
//            [resultString appendFormat: @"   %@", liju.secLijuStr];
//            [resultString appendString: @"\n"];
//        }
//        if (result.collins.collinEntrys.count ) {
//            [resultString appendString: @"\n"];
//            [resultString appendString: @"collins"];
//            [resultString appendString: @"\n"];
//            for (LPCollinsEntry *entry in result.collins.collinEntrys) {
//                for (LPCollinsEntryValueExample *ex in entry.value.examples) {
//                    [resultString appendFormat: @"%@", ex.ex];
//                    [resultString appendString: @"\n"];
//                    [resultString appendFormat: @"%@", ex.tran];
//                    [resultString appendString: @"\n"];
//                }
//            }
//        }
//        
//        [self.resultField setString: resultString];
//    } else {
//        [self.resultField setString: @""];
//    }
//
//}
//
//- (void)translateFailed:(NSError *)error
//{
//    [self.resultField setString: [error description]];
//}
//
//- (void)translateString2voiceFinished:(NSString *)audioPath source:(NSString *)string
//{
//    if (self.playSound) {
//        [self.playSound stop];
//        self.playSound = nil;
//    }
//    self.playSound = [[NSSound alloc] initWithContentsOfFile: audioPath byReference: NO];
//    [self.playSound play];
//}
//
//- (void)translateString2voiceFailed:(NSError *)error source:(NSString *)string
//{
//    
//}

@end
