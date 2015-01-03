//
//  LPTranslateResult.h
//  DaisyTranslate
//
//  Created by pennyli on 12/24/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPTranslateResult : NSObject {
    NSDictionary *_dict;
}

- (instancetype)initWithTranslateDict:(NSDictionary *)dict;

@property (nonatomic, readonly) NSMutableArray *result;
@property (nonatomic, readonly) NSMutableArray *symboles;
@property (nonatomic, readonly) NSMutableArray *lijus;

@end



#pragma mark -

@interface  LPResultData: NSObject
@property (nonatomic, strong) NSString *dst;    // 结果
@property (nonatomic, strong) NSString *src;    // 源
@end


@interface LPResultSymbole : NSObject
@property (nonatomic, strong) NSMutableArray *symboleParts; // LPSymbolePart
@property (nonatomic, strong) NSString *ph_am;              // 美氏音标
@property (nonatomic, strong) NSString *ph_en;              // 英式音标
@end

@interface LPSymbolePart : NSObject
@property (nonatomic, strong) NSArray *means;        // 词性对应的意思，数组NSString
@property (nonatomic, strong) NSString *part;        // 词性
@end


