//
//  LPCommonDefine.h
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRANSLATE_URL           @"http://fanyi.baidu.com/v2transapi"
#define AUDIO_URL               @"http://fanyi.baidu.com/gettts?"

#define TRANSLATE_PARAM_TO      @"to"
#define TRANSLATE_PARAM_FROM    @"from"
#define TRANSLATE_PARAM_QUERY   @"query"
#define TRANSLATE_PARAM_TYPE    @"transtype"

#define LANGUAGE_DETECT_URL     @"http://fanyi.baidu.com/langdetect"
#define TRANSLATE_VOICE         @"http://fanyi.baidu.com/gettts?"





#define DefineWeakVarBeforeBlock(var) \
__block __weak __typeof(var) __weak_##var = var

#define DefineStrongVarInBlock(var) \
__typeof(__weak_##var) var = __weak_##var

#define DefineWeakSelfBeforeBlock() \
__weak __typeof(self) __weak_self = self

#define DefineStrongSelfInBlock(strongSelf) \
__typeof(__weak_self) strongSelf = __weak_self


