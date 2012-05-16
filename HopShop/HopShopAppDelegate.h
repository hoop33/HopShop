//
//  HopShopAppDelegate.h
//  HopShop
//
//  Created by Rob Warner on 4/30/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OutputWindowViewController;

@interface HopShopAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet OutputWindowViewController *outputWindowViewController;

+ (HopShopAppDelegate *)delegate;

- (void)showError:(NSString *)errorMessage;
- (NSString *)pathForAppData;

@end
