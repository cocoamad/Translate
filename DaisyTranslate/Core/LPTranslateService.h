//
//  LPTranslateService.h
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPTranslateResult.h"

@interface NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;
@end

@interface NSString(GUIDAndMD5)
+ (NSString*)guid;
- (NSString *)MD5String;
@end


typedef void (^LPTranslateResultBlock)(LPTranslateResult *result);

@protocol LPTranslateServiceDelegate <NSObject>

- (void)translateDidFinished:(LPTranslateResult *)result;
- (void)translateFailed:(NSError *)error;
- (void)translateString2voiceFinished:(NSString *)audioPath source:(NSString *)string;
- (void)translateString2voiceFailed:(NSError *)error source:(NSString *)string;
@end

@interface LPTranslateService : NSObject

- (void)cancel;

@property (nonatomic, weak) id <LPTranslateServiceDelegate> delegate;

- (void)translateString:(NSString *)string from:(NSString *)fromLanguage to:(NSString *)toLanguage;

- (void)translateString:(NSString *)string from:(NSString *)fromLanguage to:(NSString *)toLanguage completeBlock:(LPTranslateResultBlock)block;

- (void)translateString2voice:(NSString *)string from:(NSString *)fromLanguage speed:(NSInteger)speed;
@end
