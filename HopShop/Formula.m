//
//  Formula.m
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "Formula.h"
#import "HopShopConstants.h"

@interface Formula (private)
- (void)loadBrewInfo;
@end

@implementation Formula

@synthesize name = _name;
@synthesize info = _info;
@synthesize version = _version;
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
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder 
{
  self = [super init];
  if (self != nil) 
  {
    _name = [decoder decodeObjectForKey:KeyName];
    _version = [decoder decodeObjectForKey:KeyVersion];
    _info = [decoder decodeObjectForKey:KeyInfo];
    _installed = [[decoder decodeObjectForKey:KeyInstalled] boolValue];
    _outdated = [[decoder decodeObjectForKey:KeyOutdated] boolValue];
  }
  return self;
}   

- (void)encodeWithCoder:(NSCoder *)encoder 
{
  [encoder encodeObject:_name forKey:KeyName];
  [encoder encodeObject:_version forKey:KeyVersion];
  [encoder encodeObject:_info forKey:KeyInfo];
  [encoder encodeObject:[NSNumber numberWithBool:self.installed] forKey:KeyInstalled];
  [encoder encodeObject:[NSNumber numberWithBool:self.outdated] forKey:KeyOutdated];
}

- (NSString *)info
{
  if (_info == nil)
  {
    [self loadBrewInfo];
  }
  return _info;
}

- (void)setInfo:(NSString *)info
{
  _info = info;
}

- (void)loadBrewInfo
{
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  [brew info:[NSArray arrayWithObject:self.name]];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ %@\n%@\n", self.name, (self.version == nil ? @"" : self.version), (self.info == nil ? @"" : self.info)];
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
  [[NSNotificationCenter defaultCenter] postNotificationName:NotificationInfoReceived object:[NSArray arrayWithObject:self]];
}

@end
