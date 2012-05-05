//
//  HopShopAppDelegate.m
//  HopShop
//
//  Created by Rob Warner on 4/30/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "HopShopAppDelegate.h"
#import "OutputWindowViewController.h"

@implementation HopShopAppDelegate

@synthesize window = _window;
@synthesize outputWindowViewController = _outputWindowViewController;

+ (HopShopAppDelegate *)delegate
{
  return (HopShopAppDelegate *)[[NSApplication sharedApplication] delegate];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

- (NSString *)pathForAppData 
{
  NSFileManager *fileManager = [NSFileManager defaultManager];  
  NSString *folder = [@"~/Library/Application Support/HopShop/" stringByExpandingTildeInPath];
  
  if (![fileManager fileExistsAtPath:folder]) {
    NSError *error;
    if (![fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error]) {
      [self showError:@"Can't create directory!"];
      // TODO Couldn't create dir
    }
  }
  return folder;
}

- (void)showError:(NSString *)errorMessage {
  
}

- (void)clearOutput 
{
  if (self.outputWindowViewController != nil)
  {
    [self.outputWindowViewController clear];
  }
}

- (void)appendToOutput:(NSString *)text
{
  if (self.outputWindowViewController != nil)
  {
    [self.outputWindowViewController append:text];
  }
}

@end
