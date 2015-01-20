//
//  AppDelegate.h
//  DaisyTranslate
//
//  Created by pennyli on 12/23/14.
//  Copyright (c) 2014 Cocoamad. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LPCoustomView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet LPCoustomView *titleBarView;

@property (nonatomic, assign) IBOutlet NSTableView *tableview;
@end

