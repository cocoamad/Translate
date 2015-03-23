//
//  AppDelegate.m
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import "AppDelegate.h"
#import "LPCommonDefine.h"
#import "INAppStoreWindow.h"
#import "LPInputTableCellView.h"
#import "LPInputFootTableCellView.h"
#import "LPTranslateResultTableCellView.h"
#import "NS(Attributed)String+Geometrics.h"

#import "AppDelegate+Setting.h"

typedef void (^WindowAnimationCompleteBlock)(void);

static NSString const *tableCellLock = @"tableCellLock";

@interface AppDelegate () <LPInputTableCellViewDelegate,
LPInputFootTableCellViewDelegate, LPTranslateServiceDelegate, NSPopoverDelegate>


@property (nonatomic, assign) NSInteger numberOfRow;

@property (nonatomic, strong) NSSound *playSound;
@property (nonatomic, assign) CGFloat resultHeight;
@property (nonatomic, assign) CGFloat inputCellHeight;

@end

@interface MyScrollView : NSScrollView
@end

@implementation MyScrollView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self hideScrollers];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self hideScrollers];
}

- (void)hideScrollers
{
    // Hide the scrollers. You may want to do this if you're syncing the scrolling
    // this NSScrollView with another one.
    [self setHasHorizontalScroller:NO];
    [self setHasVerticalScroller:NO];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    // Do nothing: disable scrolling altogether
}

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _numberOfRow = 1;
    self.inputCellHeight = InPutCellMinHeight;
    
    [self.tableview setSelectionHighlightStyle: NSTableViewSelectionHighlightStyleNone];
    [self.tableview setGridStyleMask: NSTableViewGridNone];
    [self.tableview setBackgroundColor: FootBarBackgroundColor];
    
    self.window.titleBarHeight = TitleBarHeight;
    self.window.title = @"aTranslator";
    self.window.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect,
                                         CGRectEdge edge, CGPathRef clippingPath)
    {
        CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
        CGContextSetFillColorWithColor(ctx, [NSColor colorWithCalibratedRed: 45. / 255 green: 48. / 255 blue: 50. / 255 alpha: 1].CGColor);
        CGContextAddPath(ctx, clippingPath);
        CGContextFillPath(ctx);
        

        NSSize size = [NSLocalizedString(@"aTranslator", nil) sizeWithAttributes: @{NSFontAttributeName : [NSFont systemFontOfSize: 12]}];

        CGRect titleRect = CGRectMake((drawingRect.size.width - size.width) * .5,
                                      (drawingRect.size.height - size.height) * .5, size.width, size.height);
        [NSLocalizedString(@"aTranslator", nil) drawInRect: titleRect withAttributes:
         @{NSFontAttributeName : [NSFont systemFontOfSize: 12],
           NSForegroundColorAttributeName : [NSColor whiteColor]}];
    };
    
    _hotKeyControl = [[SRRecorderControl alloc] initWithFrame: NSMakeRect(164, 35, 163, 25)];
    [self.preferenceWindow.contentView addSubview: _hotKeyControl];
    [self setRecordRecordController: _hotKeyControl WithTag: 0];
    
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
        static NSString *inputcell = @"inputcell";
        LPInputTableCellView *cell = [tableView makeViewWithIdentifier: inputcell owner: self];
        if (cell == nil) {
            cell = [[LPInputTableCellView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(tableView.frame), [self heightOfRow: row])];
            cell.delegate = self;
            cell.identifier = inputcell;
        }
        [self.window makeFirstResponder: cell.inputTextView];
        return cell;
    } else if (row == kRowFoot) {
        static NSString *footcell = @"footcell";
        LPInputFootTableCellView *cell = [tableView makeViewWithIdentifier: footcell owner: self];
        if (cell == nil) {
            cell = [[LPInputFootTableCellView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(tableView.frame), [self heightOfRow: row])];
            cell.delegate = self;
            cell.identifier = footcell;
        }
        return cell;
    } else if (row == kRowResult) {
        static NSString *resultCell = @"resultcell";
        LPTranslateResultTableCellView *cell = [tableView makeViewWithIdentifier: resultCell owner: self];
        if (cell == nil) {
            NSArray *views = nil;
            BOOL success = [[NSBundle mainBundle] loadNibNamed: @"LPTranslateResultTableCellView" owner: self topLevelObjects: &views];
            if (success && views.count) {
                for(NSView *view in views) {
                    if ([view isKindOfClass: [LPTranslateResultTableCellView class]]) {
                        cell = (LPTranslateResultTableCellView *)view;
                        cell.identifier = resultCell;
                        break;
                    }
                }
            }
        }
        return cell;
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
        return self.inputCellHeight;
    } else if (rowIndex == kRowFoot) {
        return InPutFootCellHeight;
    } else if (rowIndex == kRowResult) {
        return self.resultHeight;
    }
    return 30;
}

- (CGFloat)heightOfTableView:(NSInteger)rowNumber
{
    if (rowNumber == 1) {
        return self.inputCellHeight;
    } else if (rowNumber == 2){
        return self.inputCellHeight + InPutFootCellHeight + 6;
    } else {
        return self.inputCellHeight + InPutFootCellHeight + self.resultHeight + 6;
    }
}



#pragma mark Cell Delegate
- (void)footViewWillShow:(LPInputTableCellView *)view
{
    @synchronized(tableCellLock) {
        NSLog(@"123 %ld", _tableview.numberOfRows);
        if (_tableview.numberOfRows == 2) {
            [_tableview noteHeightOfRowsWithIndexesChanged: [NSIndexSet indexSetWithIndex: 1]];
        } else {
            [_tableview insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: 1] withAnimation: NSTableViewAnimationEffectNone];
            _numberOfRow = 2;
        }
    }
    [self doWindowAniamtion: 2 animation: YES completeBlock:^{
        
    }];
}

- (void)footViewWillHide:(LPInputTableCellView *)view
{
    self.inputCellHeight = InPutCellMinHeight;
    self.resultHeight = 0;
    
    [self doWindowAniamtion: 1 animation: YES completeBlock:^{

        @synchronized(tableCellLock) {
            NSInteger row = MAX(1, [_tableview numberOfRows]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(1, row - 1)];
            [_tableview removeRowsAtIndexes: indexSet withAnimation: NSTableViewAnimationEffectNone];
            _numberOfRow = 1;
        }
        
        [[NSAnimationContext currentContext]setDuration: 0];
        [_tableview noteHeightOfRowsWithIndexesChanged: [NSIndexSet indexSetWithIndex: 0]];
    }];
}

- (void)inputTextViewContentChanged:(LPInputTableCellView *)view height:(CGFloat)height completeBlock:(InputCellHeightChangeCompleteBlock)block
{
    BOOL needChaneged = NO;
    if (height < InPutCellMinHeight && self.inputCellHeight != InPutCellMinHeight) {
        self.inputCellHeight = InPutCellMinHeight;
        needChaneged = YES;
    } else if (height > InPutCellMinHeight) {
        self.inputCellHeight = MIN(height, InputCellMaxHeight);
        needChaneged = YES;
    }
    
    if (needChaneged) {
        [[NSAnimationContext currentContext] setDuration: 0];
        [self.tableview noteHeightOfRowsWithIndexesChanged: [NSIndexSet indexSetWithIndex: 0]];
        
        [self doWindowAniamtion: [self.tableview numberOfRows] animation: NO completeBlock:^{
            
        }];
        
        block(YES);
    }
}

- (void)translate;
{
    [self translateClick: nil];
}

- (void)translateClick:(LPInputFootTableCellView *)view;
{
    [self.service cancelAll];
    
    LPInputTableCellView *cell = [self.tableview viewAtColumn: 0 row: 0 makeIfNecessary: NO];
    if (cell) {
        NSString *translateString = cell.inputTextView.string;
        if (self.tableview.numberOfRows >= 1) {
            LPInputFootTableCellView *cell = [self.tableview viewAtColumn:0 row: 1 makeIfNecessary: YES];
            if (translateString.length) {
                [self.service translateString: translateString from: cell.fromBtn.object.key to: cell.toBtn.object.key];
            }
        }
 
    }
}

- (void)lanChooseClick:(LPInputFootTableCellView *)view lanBtn:(LPMetroButton *)btn
{

}

- (void)playSound:(NSString *)string to:(NSString *)to
{
    [self.service translateString2voice: string from: to speed: 2];
}

- (IBAction)openPerfrence:(id)sender
{
    [self.preferenceWindow makeKeyAndOrderFront: nil];
    
}

- (void)statusItemClick:(BOOL)isHilighted
{
    if (isHilighted) {
        self.hasActivePanel = YES;
    } else self.hasActivePanel = NO;
}

- (void)showPreference
{
    [self openPerfrence: nil];
}

- (void)setHasActivePanel:(BOOL)flag
{
    if (_hasActivePanel != flag) {
        _hasActivePanel = flag;
        if (_hasActivePanel) {
            [self openPanel];
        } else
            [self closePanel];
    }
}

- (void)closePanel
{
    [_window orderOut: nil];
}

- (void)openPanel
{
    NSRect screenRect = [[_window screen] frame];
    NSRect statusRect = [self statusRectForWindow: _window];
    NSRect panelRect = [_window frame];
    
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - 6))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - 6);
    [_window setAlphaValue: 1];
    [_window makeKeyWindow];
    [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
    [_window makeKeyAndOrderFront: nil];
    [_window setFrame: panelRect display: YES];
}

- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[window screen] frame];
    NSRect statusRect = NSZeroRect;
    
    if (_statusBar){
        statusRect = _statusBar.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }else{
        statusRect.size = NSMakeSize(24, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}

#pragma mark - WindowAnimation
- (void)doWindowAniamtion:(NSInteger)rowNumber animation:(BOOL)animation completeBlock:(WindowAnimationCompleteBlock)block
{
    NSRect windowRect = self.window.frame;
    CGFloat offy = [self heightOfTableView: rowNumber] + TitleBarHeight - NSHeight(windowRect);
    windowRect.size.height += offy;
    windowRect.origin.y -= offy;
    if (animation) {
        [[NSAnimationContext currentContext] setDuration: .17];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [[self.window animator] setFrame: windowRect display: NO];
        } completionHandler:^{
            if (block) {
                block();
            }
        }];
    } else {
        [self.window setFrame: windowRect display: NO];
    }

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
        _resultHeight = [[LPCommon shareCommon] heightOfTranslateResult: result width: NSWidth(_tableview.frame) - ResultCellExtraInset.left - ResultCellExtraInset.right];
         @synchronized(tableCellLock) {
             [_tableview insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: 2] withAnimation: NSTableViewAnimationEffectNone];
             _numberOfRow = 3;
         }
    } else if ([self.tableview numberOfRows] == 3) {
        _resultHeight = [[LPCommon shareCommon] heightOfTranslateResult: result width: NSWidth(_tableview.frame) - ResultCellExtraInset.left - ResultCellExtraInset.right];
        [[NSAnimationContext currentContext] setDuration: 0];
        [_tableview noteHeightOfRowsWithIndexesChanged: [NSIndexSet indexSetWithIndex: 2]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @synchronized(tableCellLock) {
            LPTranslateResultTableCellView *cell = [self.tableview viewAtColumn: 0 row: 2 makeIfNecessary: YES];
            if (cell) {
                cell.result = result;
            }
        }
        
        [self doWindowAniamtion: 3 animation: YES completeBlock: nil];
    });
}

- (void)translateFailed:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)languageDetectFindshed:(NSString *)string lan:(NSString *)lan
{
    @synchronized(tableCellLock) {
        LPInputTableCellView *cell = [self.tableview viewAtColumn: 0 row: 0 makeIfNecessary: YES];
        if (cell) {
            NSString *translateString = [cell.inputTextView string];
            if ([translateString hasPrefix: string]) {
                if (self.tableview.numberOfRows > 1) {

                    @try {
                        LPInputFootTableCellView *cell = [self.tableview viewAtColumn:0 row: 1 makeIfNecessary: YES];
                        if (cell) {
                            LPLanaguageObject *from = [[LPCommon shareCommon] languageByKey: lan];
                            LPLanaguageObject *to = [[LPCommon shareCommon] toLanguageByFromKey: lan];
                            [cell resetFromLanguage: from ToLanguage: to];
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"============exception:%@ has row:%ld", [exception description], self.tableview.numberOfRows);
                    }
                }
            }
        }
    }
}

- (void)languageDetectFailed:(NSString *)string error:(NSString *)error
{
    NSLog(@"detect string: %@ error : %@", string, error);
}

- (void)translateString2voiceFinished:(NSString *)audioPath source:(NSString *)string
{
    if (self.playSound) {
        [self.playSound stop];
        self.playSound = nil;
    }
    self.playSound = [[NSSound alloc] initWithContentsOfFile: audioPath byReference: NO];
    [self.playSound play];
}

- (void)translateString2voiceFailed:(NSError *)error source:(NSString *)string
{
    NSLog(@"play sound failed %@ source:%@", [error description], string);
}

@end

@implementation MainWindow

- (BOOL)canBecomeKeyWindow;
{
    return YES;
}

@end
