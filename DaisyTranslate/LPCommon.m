//
//  LPCommon.m
//  DaisyTranslate
//
//  Created by pennyli on 1/24/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import "LPCommon.h"

@implementation LPCommon

+ (instancetype)shareCommon;
{
    static LPCommon *g_common = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (g_common == nil) {
            g_common = [[LPCommon alloc] init];
        }
    });
    
    return g_common;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self allLanguages];
    }
    return self;
}

- (CGFloat)heightOfTranslateResult:(LPTranslateResult *)result width:(CGFloat)width
{
    NSMutableString *resultString = [NSMutableString new];
    for (LPResultData *data in result.result) {
        NSString *string = data.dst;
        [resultString appendString: string];

        if (result.means.symboles.count) {
            [resultString appendString: @"\n"];
            [resultString appendString: @"\n"];
        }
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
    
    CGFloat height = [resultString heightForWidth: width font: [NSFont systemFontOfSize: 14]];
    height += (ResultCellExtraInset.top + ResultCellExtraInset.bottom);
    
    return MIN(height, ResultCellMaxHeight);
}

- (NSArray *)allLanguages
{
    if (_lans == nil) {
        NSString *fileUrl = [[NSBundle mainBundle] pathForResource: @"languages" ofType: @"plist"];
        _lanDict = [NSDictionary dictionaryWithContentsOfFile: fileUrl];
        _lans = [NSMutableArray array];
        for (NSString *key in _lanDict) {
            LPLanaguageObject *object = [[LPLanaguageObject alloc] init];
            object.key = key;
            object.name = NSLocalizedString(_lanDict[key], nil);
            [_lans addObject: object];
        }
        [_lans sortUsingComparator:^NSComparisonResult(LPLanaguageObject * obj1, LPLanaguageObject * obj2) {
            return obj1.name.length > obj2.name.length;
        }];
    }
    return _lans;
}

- (LPLanaguageObject *)languageByKey:(NSString *)key
{
    for (LPLanaguageObject *obj in _lans) {
        if ([obj.key isEqualToString: key]) {
            return obj;
        }
    }
    return nil;
}

- (LPLanaguageObject *)toLanguageByFromKey:(NSString *)key
{
    NSString *toKey = nil;
    if ([key isEqualToString: @"en"]) {
        toKey = @"zh";
    } else if ([key isEqualToString: @"zh"]) {
        toKey = @"en";
    }
    return [self languageByKey: toKey];
}



@end

@implementation LPLanaguageObject


@end

CGPathRef createRoundRectPathInRect(CGRect rect, CGFloat radius)
{
    CGFloat mr = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect));
    
    CGFloat _radius = MIN(radius, 0.5f * mr);
    
    CGRect innerRect = CGRectInset(rect, _radius, _radius);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(innerRect) - _radius, CGRectGetMinY(innerRect));
    
    CGPathAddArc(path, NULL, CGRectGetMinX(innerRect), CGRectGetMinY(innerRect), _radius, M_PI, 3 * M_PI_2, false);
    CGPathAddArc(path, NULL, CGRectGetMaxX(innerRect), CGRectGetMinY(innerRect), _radius, 3 * M_PI_2, 0, false);
    CGPathAddArc(path, NULL, CGRectGetMaxX(innerRect), CGRectGetMaxY(innerRect), _radius, 0, M_PI_2, false);
    CGPathAddArc(path, NULL, CGRectGetMinX(innerRect), CGRectGetMaxY(innerRect), _radius, M_PI_2, M_PI, false);
    CGPathCloseSubpath(path);
    
    return path;
}

NSImage *loadImageByName(NSString *imageName)
{
    if (imageName) {
        NSString *imageFullPath = [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"];
        if (imageFullPath)
            return [[NSImage alloc] initWithContentsOfFile: imageFullPath];
    }
    return nil;
}

@implementation NSImage (Convert2CGImageRef)
- (CGImageRef)CGImageRef
{
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[self TIFFRepresentation], NULL);
    if (source) {
        CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CFRelease(source);
        return maskRef;   // should release outside
    }
    return nil;
}
@end
