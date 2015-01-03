//
//  AppDelegate.h
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSPopUpButton *fromLanBtn;
@property (weak) IBOutlet NSPopUpButton *toLanBtn;
@property (weak) IBOutlet NSTextField *translateField;
@property (weak) IBOutlet NSTextField *resultField;

- (IBAction)translate:(id)sender;
@end

