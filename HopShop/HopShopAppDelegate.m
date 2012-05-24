// Copyright (C) 2012 Rob Warner, rwarner@grailbox.com
//
// Released under the MIT license (http://www.opensource.org/licenses/MIT)
//                                
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights to 
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
// the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//                                
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//                                
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "HopShopAppDelegate.h"
#import "OutputWindowViewController.h"
#import "Brew.h"
#import "HopShopConstants.h"

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

- (void)showError:(NSString *)errorMessage 
{
  
}

#pragma mark - BrewDelegate methods

- (void)updateDidComplete:(NSString *)output
{
  [[NSNotificationCenter defaultCenter] postNotificationName:NotificationBrewUpdateCompleted object:output];
}

#pragma mark - Toolbar Item handlers

- (IBAction)brewUpdate:(id)sender
{
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  [brew update];
}

@end
