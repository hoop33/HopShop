//
//  OutputWindowViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "OutputWindowViewController.h"

@interface OutputWindowViewController ()

@end

@implementation OutputWindowViewController

@synthesize outputView;

- (void)clear
{
  [self.outputView setString:@""];
}

- (void)append:(NSString *)text
{
  NSString *output = [self.outputView string];
  [self.outputView setString:[output stringByAppendingString:text]];
}

@end
