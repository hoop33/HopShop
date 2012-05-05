//
//  Brew.m
//  HopShop
//
//  Created by Rob Warner on 5/1/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

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
  
}

- (void)uninstall:(NSArray *)formulae
{
  
}

- (void)update
{
  
}

- (void)upgrade:(NSArray *)formulae
{
  
}

- (void)info:(NSArray *)formulae
{
  
}

- (void)outdated
{
  
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
      
    default:
      break;
  }
}

@end
