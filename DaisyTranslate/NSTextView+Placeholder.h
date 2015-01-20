//
//  NSTextView+Placeholder.h
//  DaisyTranslate
//
//  Created by 鹏 李 on 1/18/15.
//  Copyright (c) 2015 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!
 *  @brief Append placeholder support.
 */
@interface NSTextView (Placeholder)

//! @brief Seems private API
@property(nonatomic, retain) NSString *placeholderString;

@end