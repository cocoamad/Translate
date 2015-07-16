//
//  LPTranslateService.m
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import "LPTranslateService.h"
#import "LPCommonDefine.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *lock = @"lock";

@interface LPTranslateService()
@property (nonatomic, strong) ASIHTTPRequest *audioRequest;
@property (nonatomic, strong) ASIFormDataRequest *translateRequest;
@property (nonatomic, strong) ASIFormDataRequest *lanDetectRequest;
@property (nonatomic, strong) NSString *audioCachePath;
@property (nonatomic, strong) NSString *detectString;
@end

@implementation LPTranslateService

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)translateString:(NSString *)string from:(NSString *)fromLanguage to:(NSString *)toLanguage
{
    if (string.length <= 0) {
        return;
    }
    NSAssert(fromLanguage != nil && toLanguage != nil, @"from language or to language is nil");
    
    [self.translateRequest clearDelegatesAndCancel];
    
    // 自动检测
    if ([fromLanguage isEqualToString: @"auto"]) {
        
    } else {
        self.translateRequest = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: TRANSLATE_URL]];
        self.translateRequest.delegate = self;
        [self.translateRequest addPostValue: fromLanguage forKey: TRANSLATE_PARAM_FROM];
        [self.translateRequest addPostValue: toLanguage forKey: TRANSLATE_PARAM_TO];
        [self.translateRequest addPostValue: string forKey: TRANSLATE_PARAM_QUERY];
        [self.translateRequest addPostValue: @"trans" forKey: TRANSLATE_PARAM_TYPE];
        self.translateRequest.showAccurateProgress = YES;
        [self.translateRequest startAsynchronous];
    }
}

- (void)cancelAll
{
    [self.translateRequest clearDelegatesAndCancel];
    [self.audioRequest clearDelegatesAndCancel];
    [self.lanDetectRequest clearDelegatesAndCancel];
}

- (void)cancelLanguageDetect;
{
    [self.lanDetectRequest clearDelegatesAndCancel];
}

- (void)translateString2voice:(NSString *)string from:(NSString *)fromLanguage speed:(NSInteger)speed;
{
    if (string.length <= 0) {
        return;
    }
    
    [self.audioRequest clearDelegatesAndCancel];
    
    string = [string URLEncodedString];
    NSString *requestUrl = [NSString stringWithFormat: @"%@&lan=%@&text=%@&spd=%ld", AUDIO_URL, fromLanguage, string, speed];
    
    self.audioRequest = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: requestUrl]];
    self.audioRequest.delegate = self;
    [self.audioRequest startAsynchronous];
}

- (void)translateStringDetect:(NSString *)string
{
    if (string.length <= 0) {
        return;
    }
    
    [self.lanDetectRequest clearDelegatesAndCancel];
    
    self.detectString = string;
    self.lanDetectRequest = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: LANGUAGE_DETECT_URL]];
    self.lanDetectRequest.delegate = self;
    [self.lanDetectRequest addPostValue: string forKey: TRANSLATE_PARAM_QUERY];
    [self.lanDetectRequest startAsynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request == self.translateRequest) {
        if ([self.delegate respondsToSelector: @selector(translateFailed:)]) {
            [self.delegate translateFailed: request.error];
        }
    } else if (request == self.audioRequest) {
        if ([self.delegate respondsToSelector: @selector(translateString2voiceFailed:source:)]) {
            [self.delegate translateString2voiceFailed: request.error source: nil];
        }
    } else if (request == self.lanDetectRequest) {
        if ([self.delegate respondsToSelector: @selector(languageDetectFailed:error:)]) {
            [self.delegate languageDetectFailed: self.detectString error: [request.error description]];
        }
    }

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request == self.translateRequest) {
        if (request.responseString) {
            NSDictionary *trans_result = request.responseString.objectFromJSONString;
            if (trans_result) {
                LPTranslateResult *result = [[LPTranslateResult alloc] initWithTranslateDict: trans_result];
                if ([self.delegate respondsToSelector: @selector(translateDidFinished:)]) {
                    [self.delegate translateDidFinished: result];
                }
            }
        }
    } else if (request == self.audioRequest) {
        NSString *audioCachePath = [[self audioCachePath] stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.mp3", [NSString guid]]];
        if (request.responseData.length) {
            BOOL success = [request.responseData writeToFile: audioCachePath atomically: YES];
            if (success && [self.delegate respondsToSelector: @selector(translateString2voiceFinished:source:)]) {
                [self.delegate translateString2voiceFinished: audioCachePath source: nil];
            }
        }
   
    } else if (request == self.lanDetectRequest) {
        NSString *jsonStr = self.lanDetectRequest.responseString;
        if (jsonStr.length) {
            NSDictionary *obj = jsonStr.objectFromJSONString;
            if ([obj[@"error"] intValue] == 0) {
                if ([self.delegate respondsToSelector: @selector(languageDetectFindshed:lan:)]) {
                    [self.delegate languageDetectFindshed: self.detectString  lan: obj[@"lan"]];
                }
            } else {
                if ([self.delegate respondsToSelector: @selector(languageDetectFailed:error:)]) {
                    [self.delegate languageDetectFailed: self.detectString error: obj[@"msg"]];
                }
            }
        }
    }

}

- (NSString *)audioCachePath
{
    if (_audioCachePath == nil) {
        NSString *userInfoPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        _audioCachePath = [userInfoPath stringByAppendingFormat:@"/aTranslator/%@", @"Audio"];
        if ([[NSFileManager defaultManager] fileExistsAtPath: _audioCachePath]) {
            return _audioCachePath;
        } else {
            NSError *error = nil;
            BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath: _audioCachePath withIntermediateDirectories: YES attributes: nil error: &error];
            if (!success) {
                NSLog(@"home path create error; %@", [error description]);
            }
            return nil;
        }
    }
    
    return _audioCachePath;
}


@end

@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8));
    return result;
}
@end

@implementation NSString(GUIDAndMD5)

+ (NSString*)guid;
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (NSString *)MD5String
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
