//
//  Formula.m
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "Formula.h"

@interface Formula (private)
- (void)loadBrewInfo;
@end

@implementation Formula

@synthesize name = _name;
@synthesize version = _version;
@synthesize info = _info;
@synthesize installed = _installed;
@synthesize outdated = _outdated;

static NSString *KeyName = @"name";
static NSString *KeyVersion = @"version";
static NSString *KeyInfo = @"info";
static NSString *KeyInstalled = @"installed";
static NSString *KeyOutdated = @"outdated";

- (id)initWithName:(NSString *)name_
{
  self = [super init];
  if (self != nil)
  {
    self.name = name_;
    [self loadBrewInfo];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder 
{
  self = [super init];
  if (self != nil) 
  {
    self.name = [decoder decodeObjectForKey:KeyName];
    self.version = [decoder decodeObjectForKey:KeyVersion];
    self.info = [decoder decodeObjectForKey:KeyInfo];
    self.installed = [[decoder decodeObjectForKey:KeyInstalled] boolValue];
    self.outdated = [[decoder decodeObjectForKey:KeyOutdated] boolValue];
  }
  return self;
}   

- (void)encodeWithCoder:(NSCoder *)encoder 
{
  [encoder encodeObject:self.name forKey:KeyName];
  [encoder encodeObject:self.version forKey:KeyVersion];
  [encoder encodeObject:self.info forKey:KeyInfo];
  [encoder encodeObject:[NSNumber numberWithBool:self.installed] forKey:KeyInstalled];
  [encoder encodeObject:[NSNumber numberWithBool:self.outdated] forKey:KeyOutdated];
}

- (void)loadBrewInfo
{
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  [brew info:[NSArray arrayWithObject:self.name]];
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
