//
//  LPTranslateResult.h
//  DaisyTranslate
//
//  Created by pennyli on 12/24/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPResultSimpleMeans;
@class LPSimpleMeansExchange;
@class LPCollinsEntryValue;
@class LPResultCollins;

@interface LPTranslateResult : NSObject {
    NSDictionary *_dict;
    NSString *_from;
    NSString *_to;
}

- (instancetype)initWithTranslateDict:(NSDictionary *)dict;

@property (nonatomic, readonly) NSMutableArray *result;
@property (nonatomic, readonly) LPResultSimpleMeans *means;
@property (nonatomic, readonly) NSMutableArray *lijus;
@property (nonatomic, readonly) LPResultCollins *collins;

@end

#pragma mark - 词典
@interface  LPResultData: NSObject
@property (nonatomic, strong) NSString *dst;    // 结果
@property (nonatomic, strong) NSString *src;    // 源
@end


@interface LPResultSimpleMeans : NSObject
@property (nonatomic, readonly) NSArray *symboles;
@property (nonatomic, readonly) LPSimpleMeansExchange *exchange;

- (instancetype)initWithSymbols:(NSArray *)symbols exchange:(NSDictionary *)exchange from:(NSString *)from to:(NSString *)to;
@end

@interface LPSimpleMeansSymbole : NSObject
@property (nonatomic, strong) NSMutableArray *symboleParts; // LPSymbolePart

@property (nonatomic, strong) NSString *ph_am;              // 美氏音标
@property (nonatomic, strong) NSString *ph_en;              // 英式音标
@end

@interface LPSimpleMeansExchange : NSObject
@property (nonatomic, strong) NSArray *word_done;          // 完成式
@property (nonatomic, strong) NSArray *word_er;            // 比较级
@property (nonatomic, strong) NSArray *word_est;           // 最高级
@property (nonatomic, strong) NSArray *word_ing;           // 正在进行氏
@property (nonatomic, strong) NSArray *word_past;          // 过去式
@property (nonatomic, strong) NSArray *word_pl;            // 复数
@property (nonatomic, strong) NSArray *word_third;
@end

@interface LPSymbolePart : NSObject
@property (nonatomic, strong) NSArray *means;        // 词性对应的意思，数组NSString
@property (nonatomic, strong) NSString *part;        // 词性
@end

#pragma mark -  例句
@interface LPResultLiju : NSObject {
    NSArray *_fristLijuWords;
    NSArray *_secLijuWords;
    NSString *_firstLijuStr;
    NSString *_secLijuStr;
}

- (instancetype)initWithDoubleLijuWords:(NSArray *)lijuwords anotherLijuWords:(NSArray *)others;

- (NSString *)firstLijuStr;
- (NSString *)secLijuStr;
@end


@interface LPLijuWord : NSObject
@property (nonatomic, strong) NSString *word; // 当前单词
@property (nonatomic, strong) NSString *flag; // 代表当前单词，类似索引
@property (nonatomic, strong) NSArray *refrenceFlags; // 相关单词对应的flag集合
@property (nonatomic, assign) BOOL isHot;       // 是否是当前单词
@property (nonatomic, assign) BOOL hasSpacing;  // 是否带“ ”
@end


#pragma mark - collins
@interface LPResultCollins : NSObject
@property (nonatomic, strong) NSArray *collinEntrys;
@property (nonatomic, strong) NSString *word_name;
- (instancetype)initWithCollinsDict:(NSDictionary *)dict;
@end

@interface LPCollinsEntry : NSObject
@property (nonatomic, strong) NSString *entry_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) LPCollinsEntryValue *value;
- (instancetype)initWithEntry:(NSDictionary *)entry;
@end

@interface LPCollinsEntryValue : NSObject
@property (nonatomic, strong) NSString *def;
@property (nonatomic, strong) NSString *head_word;
@property (nonatomic, strong) NSString *trans;
@property (nonatomic, strong) NSString *propLabel;

@property (nonatomic, strong) NSArray *examples;

- (instancetype)initWithEntryValue:(NSArray *)value WithType:(NSString *)type;
@end

@interface LPCollinsEntryValueExample : NSObject
@property (nonatomic, strong) NSString *ex;
@property (nonatomic, strong) NSString *tran;
@end



