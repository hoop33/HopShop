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

#import "Brew.h"

@interface Brew (private)
- (void)runTask:(BrewOperation)operation arguments:(NSArray *)arguments;
@end

@implementation Brew

@synthesize isRunning;
@synthesize currentOperation;
@synthesize currentOutput;
@synthesize delegate = _delegate;
@synthesize brewTask = _brewTask;

static NSDictionary *operations;

+ (void)initialize
{
  operations = [[NSDictionary alloc] initWithObjectsAndKeys:
                @"", [NSNumber numberWithInt:BrewOperationNone],
                @"list", [NSNumber numberWithInt:BrewOperationList],
                @"search", [NSNumber numberWithInt:BrewOperationSearch],
                @"install", [NSNumber numberWithInt:BrewOperationInstall],
                @"uninstall", [NSNumber numberWithInt:BrewOperationUninstall],
                @"update", [NSNumber numberWithInt:BrewOperationUpdate],
                @"upgrade", [NSNumber numberWithInt:BrewOperationUpgrade],
                @"info", [NSNumber numberWithInt:BrewOperationInfo],
                @"outdated", [NSNumber numberWithInt:BrewOperationOutdated],
                nil];
}

- (id)initWithDelegate:(id<BrewDelegate>)delegate
{
  self = [super init];
  if (self != nil)
  {
    self.delegate = delegate;
  }
  return self;
}

#pragma mark - Brew operations

- (void)search:(NSString *)searchString
{
  if (searchString == nil)
  {
    searchString = @"";
  }
  [self runTask:BrewOperationSearch arguments:[NSArray arrayWithObject:searchString]];
}

- (void)list:(NSArray *)formulae
{
  [self runTask:BrewOperationList arguments:formulae];
}

- (void)install:(NSArray *)formulae
{
  [self runTask:BrewOperationInstall arguments:formulae];
}

- (void)uninstall:(NSArray *)formulae
{
  [self runTask:BrewOperationUninstall arguments:formulae];
}

- (void)update
{
  [self runTask:BrewOperationUpdate arguments:nil];
}

- (void)upgrade:(NSArray *)formulae
{
  [self runTask:BrewOperationUpgrade arguments:formulae];
}

- (void)info:(NSArray *)formulae
{
  [self runTask:BrewOperationInfo arguments:formulae];
}

- (void)outdated
{
  [self runTask:BrewOperationOutdated arguments:nil];
}

#pragma mark - Helper methods

- (void)runTask:(BrewOperation)operation arguments:(NSArray *)arguments
{
  if (isRunning) 
  {
    [self.brewTask stopProcess];
    self.brewTask = nil;
    currentOperation = BrewOperationNone;
  } else {
    currentOperation = operation;
    NSArray *cmdLine = [self buildCommandLine:operation arguments:(NSArray *)arguments];
    self.brewTask = [[TaskWrapper alloc] initWithController:self arguments:cmdLine];
    [self.brewTask startProcess];
  }
}

- (NSArray *)buildCommandLine:(BrewOperation)operation arguments:(NSArray *)arguments {
  NSMutableArray *cmdLine = [NSMutableArray array];
  [cmdLine addObject:@"/usr/local/bin/brew"];
  NSString *command = [operations objectForKey:[NSNumber numberWithInt:operation]];
  if (command != nil && command.length > 0)
  {
    [cmdLine addObject:command];
  }
  [cmdLine addObjectsFromArray:arguments];
  return [NSArray arrayWithArray:cmdLine];
}

#pragma mark - TaskWrapperController methods

- (void)appendOutput:(NSString *)output
{
  if (currentOperation == BrewOperationUpdate) 
  {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(outputReceived:)])
    {
      [self.delegate outputReceived:output];
    }
  }
  currentOutput = [currentOutput stringByAppendingString:output];
}

- (void)processStarted
{
  currentOutput = @"";
}

- (void)processFinished
{
  NSMutableArray* array = [NSMutableArray arrayWithArray:[currentOutput componentsSeparatedByString:@"\n"]];
  [array removeLastObject];
  switch (currentOperation) {
    case BrewOperationList:
      if (self.delegate != nil && [self.delegate respondsToSelector:@selector(listDidComplete:)])
      {
        [self.delegate listDidComplete:[NSArray arrayWithArray:array]];
      }
      break;
    case BrewOperationSearch:
      if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchDidComplete:)])
      {
        [self.delegate searchDidComplete:[NSArray arrayWithArray:array]];
      }
      break;
    case BrewOperationInfo:
      if (self.delegate != nil && [self.delegate respondsToSelector:@selector(infoDidComplete:)])
      {
        [self.delegate infoDidComplete:currentOutput];
      }
      break;
    case BrewOperationUpdate:
      if (self.delegate != nil && [self.delegate respondsToSelector:@selector(updateDidComplete:)])
      {
        [self.delegate updateDidComplete:currentOutput];
      }
      break;
    default:
      break;
  }
}

@end
