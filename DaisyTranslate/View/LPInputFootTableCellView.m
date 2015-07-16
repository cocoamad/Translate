//
//  LPInputFootTableCellView.m
//  DaisyTranslate
//
//  Created by pennyli on 1/19/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPInputFootTableCellView.h"
#import "RecentListViewController.h"
#import "AppDelegate.h"
#import "LPCommon.h"


@implementation  ProgressView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame: frameRect]) {
        _progress = 1;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    if (fabs(progress - 1) < 0.000001) {
        _progress = 0;
    }
    [self setNeedsDisplay: YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = self.bounds;
    bounds.size.width = NSWidth(bounds) * _progress;
    [[NSColor redColor] setFill];
    NSRectFill(bounds);
}
@end

@interface LPInputFootTableCellView ()
@property (nonatomic, strong) NSView *toflagView;
@property (nonatomic, strong) NSButton *revertLanBtn;
@end

@implementation LPInputFootTableCellView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame: frameRect]) {
        
        LPMetroButton *fromBtn = [[LPMetroButton alloc] initWithFrame: NSZeroRect];
        fromBtn.title = NSLocalizedString(@"English", nil) ;
        fromBtn.object = [[LPCommon shareCommon] languageByKey: @"en"];
        fromBtn.mouseDownColor = nil;
        fromBtn.titleFont = [NSFont systemFontOfSize: ChooseLanFontSize];
        fromBtn.tag = 1;
        NSSize size = [self sizeOfTitle: NSLocalizedString(@"English", nil)];
        [fromBtn setFrame: NSMakeRect(ChooseLanLeftMargin, (NSHeight(self.bounds) - size.height) * .5, size.width, size.height)];
        [fromBtn addTarget: self Action: @selector(lanChooseClick:)];
        fromBtn.titleColor = [NSColor colorWithCalibratedRed: 73. / 255 green: 143. / 255 blue: 203. / 255 alpha: 1];
        [self addSubview: fromBtn];
        
        self.fromBtn = fromBtn;
        
        LPMetroButton *translateBtn = [[LPMetroButton alloc] initWithFrame: NSMakeRect(CGRectGetWidth(frameRect) - 115, 9, 100, 30)];
        [translateBtn addTarget: self Action: @selector(translate:)];
        translateBtn.title = NSLocalizedString(@"Translate", nil) ;
        translateBtn.backgroundColor = [NSColor colorWithCalibratedRed: 74. / 255 green: 104. / 255 blue: 139. / 255 alpha: 1];
        translateBtn.mouseDownColor = [NSColor colorWithCalibratedRed: 45. / 255 green: 48. / 255 blue: 50./ 255 alpha: 1];
        
        translateBtn.radius = 4;
        
        [self addSubview: translateBtn];
        
        self.toflagView = [[LPCoustomView alloc] initWithFrame: NSMakeRect(NSMaxX(self.fromBtn.frame) + ChooseLanBtnSpacing, (NSHeight(self.frame) - 2) * .5 - 2, 5, 2)DrawBackgroundBlock:^(CGContextRef ctx, NSRect rect) {
            [NSRGBAColor(148, 173, 188, 1) setFill];
            NSRectFill(rect);
        }];
        
        [self addSubview: self.toflagView];
        
        LPMetroButton *toBtn = [[LPMetroButton alloc] initWithFrame: NSZeroRect];
        toBtn.tag = 2;
        toBtn.mouseDownColor = nil;
        toBtn.title = NSLocalizedString(@"Chinese", nil);
        toBtn.object = [[LPCommon shareCommon] languageByKey: @"zh"];
        size = [self sizeOfTitle: NSLocalizedString(@"Chinese", nil)];
        [toBtn setFrame: NSMakeRect(NSMaxX(self.toflagView.frame) + ChooseLanBtnSpacing, (NSHeight(self.bounds) - size.height) * .5, size.width, size.height)];
        toBtn.titleFont = [NSFont systemFontOfSize: ChooseLanFontSize];
        [toBtn addTarget: self Action: @selector(lanChooseClick:)];
        toBtn.titleColor = [NSColor colorWithCalibratedRed: 73. / 255 green: 143. / 255 blue: 203. / 255 alpha: 1];
        [self addSubview: toBtn];
        
        self.toBtn = toBtn;
        
        
        self.revertLanBtn = [[NSButton alloc] initWithFrame: NSMakeRect(NSMaxX(self.toBtn.frame) + 10, (NSHeight(self.bounds) - 22) * .5 - 1, 28, 22)];
        [self.revertLanBtn  setImage: [NSImage imageNamed: @"revert"]];
        [self.revertLanBtn setTarget: self];
        [self.revertLanBtn setAction: @selector(revertLan:)];
        [self.revertLanBtn setBordered: NO];
        [self.revertLanBtn setBezelStyle: NSShadowlessSquareBezelStyle];
        [self.revertLanBtn setButtonType: NSMomentaryChangeButton];
        
        [self addSubview: self.revertLanBtn];
        
    }
    return self;
}

- (void)translate:(id)sender
{
    if (_delegate && [_delegate respondsToSelector: @selector(translateClick:)]) {
        [_delegate translateClick: self];
    }
}

- (void)revertLan:(id)sender
{
    [self resetFromLanguage: self.toBtn.object ToLanguage: self.fromBtn.object];
}

- (void)lanChooseClick:(LPMetroButton *)btn
{
    if (self.lanPopover == nil) {
        if (self.lanPopover == nil) {
            RecentListViewController *recentListVC = [[RecentListViewController alloc] initWithNibName: @"RecentListViewController" bundle: nil] ;
            
            self.lanPopover = [[INPopoverController alloc] initWithContentViewController: recentListVC];
            self.lanPopover.color = LanChoosePopoverColor;
            self.lanPopover.borderColor = LanChoosePopoverColor;
            self.lanPopover.delegate = self;
        }
    }
    __weak LPInputFootTableCellView *weakCell = self;
    RecentListViewController *vc = (RecentListViewController *)self.lanPopover.contentViewController;
    vc.isFromPop = (btn.tag == 1);
    vc.selectedLanBlock = ^(LPLanaguageObject *lan){
        if (btn.tag == 1) {
            [self resetFromLanguage: lan ToLanguage: nil];
        } else if (btn.tag == 2) {
            [self resetFromLanguage: nil ToLanguage: lan];
        }
        [weakCell.lanPopover closePopover: nil];
    };
    
    if (btn == self.toBtn) {
        
    }
    [self.lanPopover presentPopoverFromRect: btn.bounds inView: btn preferredArrowDirection: INPopoverArrowDirectionUp anchorsToPositionView: YES];
}

- (void)popoverDidClose:(INPopoverController *)popover;
{

}

- (void)popoverWillShow:(INPopoverController *)popover;
{
    RecentListViewController *vc = (RecentListViewController *)self.lanPopover.contentViewController;
    [vc layoutItem];
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    CGContextSetFillColorWithColor(ctx, FootBarBackgroundColor.CGColor);
    CGContextFillRect(ctx, self.bounds);
}

- (void)resetFromLanguage:(LPLanaguageObject *)from ToLanguage:(LPLanaguageObject *)to
{
    if (from) {
        self.fromBtn.object = from;
        self.fromBtn.title = from.name;
        NSString *fromName = from.name;
        NSSize size = [self sizeOfTitle: fromName];
        NSRect fromBtnRect = self.fromBtn.frame;
        fromBtnRect = NSMakeRect(NSMinX(fromBtnRect), NSMinY(fromBtnRect),size.width, size.height);
        self.fromBtn.frame = fromBtnRect;
        [LPCommon shareCommon].fromLan = from;
        self.toflagView.frame = NSMakeRect(NSMaxX(self.fromBtn.frame) + 5, (NSHeight(self.frame) - 2) * .5 - 2, 5, 2);
    }
    
    if (to) {
        self.toBtn.object = to;
        self.toBtn.title = to.name;
        NSRect toBtnFrame = self.toBtn.frame;
        NSSize size = [self sizeOfTitle: to.name];
        toBtnFrame.origin.x = NSMaxX(self.toflagView.frame) + ChooseLanBtnSpacing;
        toBtnFrame.size = size;
        [LPCommon shareCommon].toLan = to;
        [self.toBtn setFrame: toBtnFrame];
    } else {
        NSRect toBtnFrame = self.toBtn.frame;
        toBtnFrame.origin.x = NSMaxX(self.toflagView.frame) + ChooseLanBtnSpacing;
        [self.toBtn setFrame: toBtnFrame];
    }
    
    self.revertLanBtn.frame = NSMakeRect(NSMaxX(self.toBtn.frame) + 10, (NSHeight(self.bounds) - 22) * .5 - 1, 28, 22);
}

- (NSSize)sizeOfTitle:(NSString *)title
{
    if (title) {
        NSSize size = [title sizeWithAttributes: @{NSFontAttributeName : [NSFont systemFontOfSize: ChooseLanFontSize]}];
        
        return NSMakeSize(size.width + 2 * ChooseLanBtnLeftAndRightPadding, size.height + 10);
    }
    return NSZeroSize;
}

@end
