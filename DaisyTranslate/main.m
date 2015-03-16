//
//  main.m
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

void registerUserDefault()
{
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{@"openTranslateWindow" : @{@"code" : @1, @"flag" : @1179648}}];
}

int main(int argc, const char * argv[]) {
    registerUserDefault();
    return NSApplicationMain(argc, argv);
}
