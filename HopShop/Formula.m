//
//  Formula.m
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "Formula.h"

@implementation Formula

@synthesize name;
@synthesize version;
@synthesize info;
@synthesize installed;
@synthesize outdated;

- (id)initWithName:(NSString *)name_
{
  self = [super init];
  if (self != nil)
  {
    self.name = name_;
    Brew *brew = [[Brew alloc] initWithDelegate:self];
    [brew info:[NSArray arrayWithObject:self.name]];
  }
  return self;
}

#pragma mark - BrewDelegate methods

- (void)infoDidComplete:(NSString *)output
{
  if (output != nil)
  {
    NSRange range = [output rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    if (range.location > 0)
    {
      self.info = [output substringFromIndex:(range.location + 1)];
      self.version = [[[output substringToIndex:range.location] componentsSeparatedByString:@" "] lastObject];
    }
  }
}

@end
