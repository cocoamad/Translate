//
//  LPTranslateResult.m
//  DaisyTranslate
//
//  Created by pennyli on 12/24/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import "LPTranslateResult.h"
#import "JSONKit.h"

@implementation LPTranslateResult
@synthesize result = _result;
@synthesize symboles = _symboles;
@synthesize lijus = _lijus;

- (instancetype)initWithTranslateDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _dict = dict;
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


- (NSArray *)symboles
{
    if (_symboles == nil) {
        @try {
            NSArray *symboles = _dict[@"dict_result"][@"simple_means"][@"symbols"];
            if (symboles.count) {
                _symboles = [NSMutableArray array];
                for (NSDictionary *dict in symboles) {
                    LPResultSymbole *symbole = [[LPResultSymbole alloc] init];
                    symbole.ph_am = dict[@"ph_am"];
                    symbole.ph_en = dict[@"ph_en"];
                    if ([dict[@"parts"] count]) {
                        symbole.symboleParts = [NSMutableArray array];
                        for (NSDictionary *partDict in dict[@"parts"]) {
                            LPSymbolePart *part = [[LPSymbolePart alloc] init];
                            part.means = partDict[@"means"];
                            part.part = partDict[@"part"];
                            [symbole.symboleParts addObject: part];
                        }
                    }
                    [_symboles addObject: symbole];
                }
            }

        }
        @catch (NSException *exception) {
            _symboles = [NSMutableArray array];
        }
    }
    return _symboles;
}

- (NSMutableArray *)lijus
{
    if (_lijus == nil) {
        @try {
            NSDictionary *lijuDict = _dict[@"liju_result"];
            id obj = [lijuDict[@"double"] objectFromJSONString];
            NSLog(@"%@", obj);
        } @catch (NSException *exception){
        
        }
    }
}
@end


#pragma mark  -

@implementation LPSymbolePart
@end

@implementation LPResultData
@end

@implementation LPResultSymbole
@end
