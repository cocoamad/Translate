//
//  AppDelegate.m
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import "AppDelegate.h"
#import "LPTranslateService.h"
#import "LPCommonDefine.h"


@interface AppDelegate () <LPTranslateServiceDelegate>

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSDictionary *languageDict;

@property (nonatomic, strong) LPTranslateService *service;


@property (nonatomic, strong) NSSound *playSound;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.service = [[LPTranslateService alloc] init];
    self.service.delegate = self;
    
    NSString *lanDictFilePath = [[NSBundle mainBundle] pathForResource: @"languages" ofType: @"plist"];
    self.languageDict = [NSDictionary dictionaryWithContentsOfFile: lanDictFilePath];
    if ([self.languageDict count]) {
        NSMutableArray *keys = [NSMutableArray arrayWithArray:[self.languageDict allKeys]];
        [self.fromLanBtn addItemsWithTitles:keys];
        [keys removeObject: @"自动检测"];
        [self.toLanBtn addItemsWithTitles: keys];
        
        [self.fromLanBtn selectItemWithTitle: @"中文"];
        [self.toLanBtn selectItemWithTitle: @"英语"];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark Action

- (IBAction)translate:(id)sender
{
    NSString *translateString = self.translateField.stringValue;
    if (translateString.length) {
        NSString *from =  [self.languageDict objectForKey: [[self.fromLanBtn selectedItem] title]];
        NSString *to = [self.languageDict objectForKey: [[self.toLanBtn selectedItem] title]];
        [self.service translateString: translateString from: from to: to];
    }
}

- (IBAction)playSound:(id)sender
{
    NSString *translateString = self.translateField.stringValue;
    if (translateString.length) {
        NSString *from =  [self.languageDict objectForKey: [[self.fromLanBtn selectedItem] title]];
        [self.service translateString2voice: translateString from: from speed: 2];
    }
}

#pragma mark Translate Service Delegate

- (void)translateDidFinished:(LPTranslateResult *)result
{
    if (result) {
        NSMutableString *resultString = [NSMutableString new];
        
        for (LPResultData *data in result.result) {
            NSString *string = data.dst;
            [resultString appendString: string];
            [resultString appendString: @"\n"];
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
            [resultString appendFormat: @"\n"];
            
            for (LPSymbolePart *part in symbole.symboleParts) {
                if (part.part.length)
                    [resultString appendFormat: @"%@  ", part.part];
                for (NSString *mean in part.means) {
                    [resultString appendFormat: @"%@;", mean];
                }
                [resultString appendFormat: @"\n"];
            }
        }
        NSInteger index = 1;
        for (LPResultLiju *liju in result.lijus) {
            [resultString appendFormat: @"%ld.  %@", index++,liju.firstLijuStr];
            [resultString appendString: @"\n"];
            [resultString appendFormat: @"   %@", liju.secLijuStr];
            [resultString appendString: @"\n"];
        }
        [self.resultField setString: resultString];
    } else {
        [self.resultField setString: @""];
    }

}

- (void)translateFailed:(NSError *)error
{
    [self.resultField setString: [error description]];
}

- (void)translateString2voiceFinished:(NSString *)audioPath source:(NSString *)string
{
    if (self.playSound) {
        [self.playSound stop];
        self.playSound = nil;
    }
    self.playSound = [[NSSound alloc] initWithContentsOfFile: audioPath byReference: NO];
    [self.playSound play];
}

- (void)translateString2voiceFailed:(NSError *)error source:(NSString *)string
{
    
}

@end
