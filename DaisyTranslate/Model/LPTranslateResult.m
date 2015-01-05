//
//  LPTranslateResult.m
//  DaisyTranslate
//
//  Created by pennyli on 12/24/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import "LPTranslateResult.h"
#import "JSONKit.h"

#define SAFT_NSSTRING(str) [str isKindOfClass: [NSNull class]] == YES ? @"" : str

@implementation LPTranslateResult
@synthesize result = _result;
@synthesize means = _means;
@synthesize lijus = _lijus;

- (instancetype)initWithTranslateDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _dict = dict;
        @try {
            _from = _dict[@"trans_result"][@"from"];
            _to = _dict[@"trans_result"][@"to"];
            NSLog(@"from: %@, to: %@", _from, _to);
        }
        @catch (NSException *exception) {
            
        }
    }
    return self;
}

- (NSArray *)result
{
    if (_result == nil) {
        @try {
            NSArray *result = _dict[@"trans_result"][@"data"];
            if (result.count) {
                _result = [NSMutableArray array];
                for (NSDictionary *dict in result) {
                    LPResultData *data = [[LPResultData alloc] init];
                    data.dst = dict[@"dst"];
                    data.src  =dict[@"src"];
                    [_result addObject: data];
                }
            }
        }
        @catch (NSException *exception) {
            _result = [NSMutableArray array];
        }
    }
    return _result;
}

- (LPResultSimpleMeans *)means
{
    if (_means == nil) {
        @try {
            NSDictionary *simple_means = _dict[@"dict_result"][@"simple_means"];
            NSDictionary *exchange = simple_means[@"exchange"];
            NSArray *symboles = simple_means[@"symbols"];
            _means = [[LPResultSimpleMeans alloc] initWithSymbols: symboles exchange: exchange from: _from to: _to];
        }
        @catch (NSException *exception) {
            _means = [[LPResultSimpleMeans alloc] init];
        }
    }
    return _means;
}

- (NSMutableArray *)lijus
{
    if (_lijus == nil) {
        @try {
            NSDictionary *lijuDict = _dict[@"liju_result"];
            NSString *lijuStr = lijuDict[@"double"];
            lijuStr = [lijuStr stringByReplacingOccurrencesOfString: @"\\" withString: @""];
            NSArray *lijus = lijuStr.objectFromJSONString;
            if (lijus.count) {
                _lijus = [NSMutableArray array];
                for (NSArray *liju in lijus) {
                    if (liju.count != 4) {
                        continue;
                    }
                    LPResultLiju *lijuObject = [[LPResultLiju alloc] initWithDoubleLijuWords: liju[0] anotherLijuWords: liju[1]];
                    [_lijus addObject: lijuObject];
                    
                }
            }
        } @catch (NSException *exception){
            _lijus = [NSMutableArray array];
        }
    }
    return _lijus;
}

- (void)dealloc
{
    [_lijus removeAllObjects];
    _means = nil;
    _result = nil;
}
@end


#pragma mark  -

@implementation LPSymbolePart

- (void)dealloc
{
    _means = nil;
    _part = nil;
}
@end

@implementation LPResultData
- (void)dealloc
{
    _dst = nil;
    _src = nil;
}
@end

@interface LPResultSimpleMeans()
@end

@implementation LPResultSimpleMeans
@synthesize symboles = _symboles;

- (instancetype)init
{
    if (self = [super init]) {
        _symboles = nil;
        _exchange = nil;
    }
    return self;
}

- (instancetype)initWithSymbols:(NSArray *)symbols exchange:(NSDictionary *)exchange from:(NSString *)from to:(NSString *)to
{
    if (self = [super init]) {
        _symboles = [self parseSymbols: symbols from: from to: to];
        _exchange = [self parseExchange: exchange];
    }
    return self;
}

- (NSArray *)parseSymbols:(NSArray *)symbols from: from to: to
{
    NSMutableArray *symbolsobj = nil;
    @try {
        if (symbols.count) {
            symbolsobj = [NSMutableArray array];
            for (NSDictionary *dict in symbols) {
                LPSimpleMeansSymbole *symbole = [[LPSimpleMeansSymbole alloc] init];
                symbole.ph_am = SAFT_NSSTRING(dict[@"ph_am"]);
                symbole.ph_en = SAFT_NSSTRING(dict[@"ph_en"]);
                
                if ([dict[@"parts"] count]) {
                    symbole.symboleParts = [NSMutableArray array];
                    for (NSDictionary *partDict in dict[@"parts"]) {
                        LPSymbolePart *part = [[LPSymbolePart alloc] init];
                        
                        if ([from isEqualToString: @"zh"] && [to isEqualToString: @"en"]) {
                            NSArray *meanDicts = partDict[@"means"];
                            if (meanDicts.count) {
                                NSMutableArray *means = [NSMutableArray array];
                                for (NSDictionary *meanDict in partDict[@"means"]) {
                                    [means addObject: SAFT_NSSTRING(meanDict[@"word_mean"])];
                                }
                                part.means = means;
                            }
                        } else {
                            part.means = SAFT_NSSTRING(partDict[@"means"]);
                        }
                        
                        part.part = SAFT_NSSTRING(partDict[@"part"]);
                        [symbole.symboleParts addObject: part];
                    }
                }
                [symbolsobj addObject: symbole];
            }
        }
        
    }
    @catch (NSException *exception) {
        symbolsobj = nil;
    }
    return symbolsobj;
}

- (LPSimpleMeansExchange *)parseExchange:(NSDictionary *)exchange
{
    @try {
        if (exchange.count) {
            LPSimpleMeansExchange *ec = [[LPSimpleMeansExchange alloc] init];
            ec.word_done = SAFT_NSSTRING(exchange[@"word_done"]);
            ec.word_er = SAFT_NSSTRING(exchange[@"word_er"]);
            ec.word_est = SAFT_NSSTRING(exchange[@"word_est"]);
            ec.word_ing = SAFT_NSSTRING(exchange[@"word_ing"]);
            ec.word_past = SAFT_NSSTRING(exchange[@"word_past"]);
            ec.word_pl = SAFT_NSSTRING(exchange[@"word_pl"]);
            ec.word_third = SAFT_NSSTRING(exchange[@"word_third"]);
            return ec;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

- (void)dealloc
{
    _symboles = nil;
    _exchange = nil;
}

@end

@implementation LPSimpleMeansSymbole

- (void)dealloc
{
    [_symboleParts removeAllObjects];
    _symboleParts = nil;
    _ph_am = nil;
    _ph_en = nil;
}

@end


@implementation LPSimpleMeansExchange

- (void)dealloc
{
    _word_done = nil;
    _word_er = nil;
    _word_est = nil;
    _word_ing = nil;
    _word_past = nil;
    _word_pl = nil;
    _word_third = nil;
}
@end


@implementation LPResultLiju

- (instancetype)initWithDoubleLijuWords:(NSArray *)lijuwords anotherLijuWords:(NSArray *)others
{
    if (self = [super init]) {
        if (lijuwords.count) {
            _fristLijuWords = [self parseLijuWords: lijuwords];
            _secLijuWords = [self parseLijuWords: others];
        }
    }
    return self;
}

- (NSString *)firstLijuStr
{
    if (_firstLijuStr == nil) {
        NSMutableString *string = [NSMutableString new];
        for (LPLijuWord *word in _fristLijuWords) {
            [string appendString: word.word];
            if ([word hasSpacing]) {
                [string appendString: @" "];
            }
        }
        _firstLijuStr = [NSString stringWithString: string];
    }
    return _firstLijuStr;

}

- (NSString *)secLijuStr
{
    if (_secLijuStr == nil) {
        NSMutableString *string = [NSMutableString new];
        for (LPLijuWord *word in _secLijuWords) {
            [string appendString: word.word];
            if ([word hasSpacing]) {
                [string appendString: @" "];
            }
        }
        _secLijuStr = [NSString stringWithString: string];
    }
    return _secLijuStr;
}

- (NSArray *)parseLijuWords:(NSArray *)lijuwords
{
    NSMutableArray *resultWords = nil;
    if (lijuwords.count) {
        resultWords = [NSMutableArray array];
        for (NSArray *jsonWord in lijuwords) {
            if (jsonWord.count < 4) {
                continue;
            }
            
            LPLijuWord *word = [[LPLijuWord alloc] init];
            word.word = jsonWord[0];
            word.flag = jsonWord[1];
            word.refrenceFlags = [jsonWord[2] componentsSeparatedByString: @","];
            word.isHot = (BOOL)jsonWord[3];
            if (jsonWord.count == 5) {
                word.hasSpacing = [jsonWord[4] isEqualToString: @" "];
            } else word.hasSpacing = NO;
            
            [resultWords addObject: word];
        }
    }
    return resultWords;
}

- (void)dealloc
{
    _firstLijuStr = nil;
    _secLijuStr = nil;
    _fristLijuWords = nil;
    _secLijuWords = nil;
}
@end

@implementation LPLijuWord

- (void)dealloc
{
    _word = nil;
    _flag = nil;
    _refrenceFlags = nil;
}

@end
