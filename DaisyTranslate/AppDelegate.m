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
#import "LPTranslateResultTableCellView.h"
#import "NS(Attributed)String+Geometrics.h"

typedef enum {
    kRowInput = 0,
    kRowFoot,
    kRowResult
} ROW_TYPE;

#define InPutCellHeight 156
#define InPutFootCellHeight 42
#define TitleBarHeight 22
#define ResultCellExtraInset  NSEdgeInsetsMake(10, 5, 20, 5)

typedef void (^WindowAnimationCompleteBlock)(void);

@interface AppDelegate () <LPInputTableCellViewDelegate,
LPInputFootTableCellViewDelegate, LPTranslateServiceDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, assign) NSInteger numberOfRow;
@property (nonatomic, assign) CGFloat resultHeight;
@property (nonatomic, strong) LPTranslateService *service;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _numberOfRow = 1;
    [self.tableview setSelectionHighlightStyle: NSTableViewSelectionHighlightStyleNone];
    [self.tableview setGridStyleMask: NSTableViewGridNone];
    self.tableview.backgroundColor = [NSColor colorWithCalibratedRed: 44. / 255 green: 60. / 255 blue: 71. / 255 alpha: 1];
//    self.window.titleBarHeight = TitleBarHeight;
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

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7);
{
    if (row == kRowInput) {
        LPInputTableCellView *cell = [[LPInputTableCellView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(tableView.frame), [self heightOfRow: row])];

        cell.delegate = self;
        [self.window makeFirstResponder: cell.inputTextView];
        
        return cell;
    } else if (row == kRowFoot) {
        LPInputFootTableCellView *cell = [[LPInputFootTableCellView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(tableView.frame), [self heightOfRow: row])];
        cell.delegate = self;
        return cell;
    } else if (row == kRowResult) {
        NSArray *views = nil;
        BOOL success = [[NSBundle mainBundle] loadNibNamed: @"LPTranslateResultTableCellView" owner: self topLevelObjects: &views];
        if (success && views.count) {
            for(NSView *view in views) {
                if ([view isKindOfClass: [LPTranslateResultTableCellView class]])
                    return view;
            }
        }
        return nil;
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

#pragma mark calc height
- (CGFloat)heightOfRow:(NSInteger)rowIndex
{
    if (rowIndex == kRowInput) {
        return InPutCellHeight;
    } else if (rowIndex == kRowFoot) {
        return InPutFootCellHeight;
    } else if (rowIndex == kRowResult) {
        return _resultHeight;
    }
    return 30;
}

- (CGFloat)heightOfTableView:(NSInteger)rowNumber
{
    if (rowNumber == 1) {
        return InPutCellHeight;
    } else if (rowNumber == 2){
        return InPutCellHeight + InPutFootCellHeight;
    } else {
        return InPutCellHeight + InPutFootCellHeight + _resultHeight;
    }
}

- (CGFloat)heightOfTranslateResult:(LPTranslateResult *)result
{
    NSMutableString *resultString = [NSMutableString new];
    for (LPResultData *data in result.result) {
        NSString *string = data.dst;
        [resultString appendString: string];
        [resultString appendString: @"\n"];
        [resultString appendString: @"\n"];
    }
    
    for (LPSimpleMeansSymbole *symbole in result.means.symboles) {
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
    
    CGFloat height = [resultString heightForWidth: NSWidth(_tableview.frame) - ResultCellExtraInset.left - ResultCellExtraInset.right font: [NSFont systemFontOfSize: 12]];
    height += (ResultCellExtraInset.top + ResultCellExtraInset.bottom);
    
    return height;
}

#pragma mark Cell Delegate
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
        NSInteger row = MAX(1, [_tableview numberOfRows]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(1, row - 1)];
        [_tableview removeRowsAtIndexes: indexSet withAnimation: NSTableViewAnimationEffectNone];
        _numberOfRow = 1;
    }];
}


- (void)translateClick:(LPInputFootTableCellView *)view;
{
    [self.service cancel];
    
    LPInputTableCellView *cell = [self.tableview viewAtColumn: 0 row: 0 makeIfNecessary: NO];
    if (cell) {
        NSString *translateString = cell.inputTextView.string;
        if (translateString.length) {
            [self.service translateString: translateString from: @"en" to: @"zh"];
        }
    }
}

#pragma mark - WindowAnimation
- (void)doWindowAniamtion:(NSInteger)rowNumber completeBlock:(WindowAnimationCompleteBlock)block
{
    NSRect windowRect = self.window.frame;
    CGFloat offy = [self heightOfTableView: rowNumber] + TitleBarHeight - NSHeight(windowRect);
    windowRect.size.height += offy;
    windowRect.origin.y -= offy;
    [[NSAnimationContext currentContext] setDuration: .17];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [[self.window animator] setFrame: windowRect display: NO];
    } completionHandler:^{
        if (block) {
            block();
        }
    }];
}

#pragma mark - Translate Service
- (LPTranslateService *)service
{
    if (_service == nil) {
        _service = [[LPTranslateService alloc] init];
        _service.delegate = self;
    }
    return _service;
}

- (void)translateDidFinished:(LPTranslateResult *)result
{
    if ([self.tableview numberOfRows] == 2) {
        _resultHeight = [self heightOfTranslateResult: result];
        [_tableview insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: 2] withAnimation: NSTableViewAnimationEffectNone];
        _numberOfRow = 3;
    } else if ([self.tableview numberOfRows] == 3) {
        _resultHeight = [self heightOfTranslateResult: result];
        [_tableview noteHeightOfRowsWithIndexesChanged: [NSIndexSet indexSetWithIndex: 2]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LPTranslateResultTableCellView *cell = [self.tableview viewAtColumn: 0 row: 2 makeIfNecessary: NO];
        if (cell) {
            cell.result = result;
        }
    });
    [self doWindowAniamtion: 3 completeBlock: nil];
}

- (void)translateFailed:(NSError *)error
{
    NSLog(@"%@", error);
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
