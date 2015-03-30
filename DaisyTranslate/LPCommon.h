//
//  LPCommon.h
//  DaisyTranslate
//
//  Created by pennyli on 1/24/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPTranslateResult.h"
#import "NS(Attributed)String+Geometrics.h"

typedef enum {
    kRowInput = 0,
    kRowFoot,
    kRowResult
} ROW_TYPE;

#define kUserDefault_AutoCopyToPasteboard @"kUserDefault_AutoCopyToPasteboard"
#define kUserDefault_AutoLoginWhenStartup @"kUserDefault_AutoLoginWhenStartup"

#define InPutCellMinHeight 157
#define InputCellMaxHeight 300

#define InPutFootCellHeight 50
#define TitleBarHeight 28
#define ResultCellExtraInset  NSEdgeInsetsMake(0, 10, 30, 10)

#define ResultCellMaxHeight 300

#define NSRGBAColor(r, g, b, a) [NSColor colorWithCalibratedRed: (r) * 1.0 / 255 green: (g) * 1.0 / 255 blue: (b) * 1.0 / 255 alpha: (a)]

#pragma mark - 
#define LanChoosePopoverColor NSRGBAColor(54, 76, 100, 1)
#define FootBarBackgroundColor NSRGBAColor(44, 60, 72, 1)

#define TRANS_BUTTON_SIZE NSMakeSize(80, 30)
#define LAN_BUTTON_SIZE NSMakeSize(40, 22)

#define ChooseLanLeftMargin 10
#define ChooseLanBtnLeftAndRightPadding 5
#define ChooseLanBtnSpacing 3
#define ChooseLanFontSize 14

typedef void (^InputCellHeightChangeCompleteBlock)(BOOL changed);

@class LPLanaguageObject;

CGPathRef createRoundRectPathInRect(CGRect rect, CGFloat radius);

@interface LPCommon : NSObject {
    NSDictionary *_lanDict;
    NSMutableArray *_lans;
}
+ (instancetype)shareCommon;
- (CGFloat)heightOfTranslateResult:(LPTranslateResult *)result width:(CGFloat)width;

- (NSArray *)allLanguages;
- (LPLanaguageObject *)toLanguageByFromKey:(NSString *)key;
- (LPLanaguageObject *)languageByKey:(NSString *)key;
@end

@interface LPLanaguageObject : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;
@end

NSImage *loadImageByName(NSString *imageName);

@interface NSImage (Convert2CGImageRef)
-(CGImageRef)CGImageRef;
@end

#ifdef __DEBUG__
#define debug_log(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define debug_log(format, ...)
#endif
