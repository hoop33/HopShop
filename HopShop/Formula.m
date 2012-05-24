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

- (NSAttributedString *)fancyDescription
{
  NSMutableAttributedString *fancy = [[NSMutableAttributedString alloc] init];
  
  // Add the name
  [fancy appendAttributedString:[[NSAttributedString alloc] initWithString:self.name attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:18.0f], NSFontAttributeName, [NSColor colorWithDeviceRed:0.0f green:0.5f blue:0.0f alpha:1.0f], NSForegroundColorAttributeName, nil]]];
  
  // Add the version
  if (self.version != nil)
  {
    [fancy appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", self.version] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:12.0], NSFontAttributeName, [NSColor brownColor], NSForegroundColorAttributeName, nil]]];
  }
  
  // Add the info
  if (self.info != nil)
  {
    NSMutableAttributedString *fancyInfo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", self.info]];
    
    // Detect the URLs
    int index = 1; // Skip the leading newline
    for (NSString *word in [self.info componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])
    {
      if ([word hasPrefix:@"http"])
      {
        [fancyInfo addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSColor blueColor], NSForegroundColorAttributeName,
                                  [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName, 
                                  word, NSLinkAttributeName, nil] 
                           range:NSMakeRange(index, [word length])];
      }
      index += [word length] + 1;
    }

    // Put in output
    [fancy appendAttributedString:fancyInfo];
  }
  
  return fancy;
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
