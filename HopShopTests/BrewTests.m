//
//  BrewTests.m
//  HopShop
//
//  Created by Rob Warner on 5/1/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "BrewTests.h"

@implementation BrewTests

- (void)testWithNilDelegateShouldHaveNilDelegate
{
  Brew *brew = [[Brew alloc] initWithDelegate:nil];
  STAssertNil(brew.delegate, @"initWithDelegate should have nil delegate");
}

- (void)testWithDelegateShouldHaveDelegate
{
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  STAssertEqualObjects(self, brew.delegate, @"Brew's delegate should have been self");
}

- (void)testBrewShouldRespondToAppendOutput
{
  Brew *brew = [[Brew alloc] init];
  STAssertTrue([brew respondsToSelector:@selector(appendOutput:)], @"Brew should respond to appendOutput:");
}

- (void)testBrewShouldRespondToProcessStarted
{
  Brew *brew = [[Brew alloc] init];
  STAssertTrue([brew respondsToSelector:@selector(processStarted)], @"Brew should respond to processStarted");
}

- (void)testBrewShouldRespondToProcessFinished
{
  Brew *brew = [[Brew alloc] init];
  STAssertTrue([brew respondsToSelector:@selector(processFinished)], @"Brew should respond to processFinished");
}

- (void)testBuildEmptyCommandLineShouldHaveBrewAndOperation
{
  Brew *brew = [[Brew alloc] initWithDelegate:nil];
  NSArray *cmdLine = [brew buildCommandLine:BrewOperationInfo arguments:nil];
  STAssertEquals((NSUInteger)2, cmdLine.count, @"Command line should have 2 items");
  STAssertEqualObjects(@"/usr/local/bin/brew", [cmdLine objectAtIndex:0], @"First item should have been brew executable");
  STAssertEqualObjects(@"info", [cmdLine objectAtIndex:1], @"Second item should have been info");
}

- (void)testBuildOneArgCommandLineShouldHaveBrewOperationAndArgument
{
  Brew *brew = [[Brew alloc] initWithDelegate:nil];
  NSArray *cmdLine = [brew buildCommandLine:BrewOperationInfo arguments:[NSArray arrayWithObject:@"git"]];
  STAssertEquals((NSUInteger)3, cmdLine.count, @"Command line should have 2 items");
  STAssertEqualObjects(@"/usr/local/bin/brew", [cmdLine objectAtIndex:0], @"First item should have been brew executable");
  STAssertEqualObjects(@"info", [cmdLine objectAtIndex:1], @"Second item should have been info");
  STAssertEqualObjects(@"git", [cmdLine objectAtIndex:2], @"Third item should have been git");
}

- (void)testBuildTwoArgCommandLineShouldHaveBrewOperationAndArguments
{
  Brew *brew = [[Brew alloc] initWithDelegate:nil];
  NSArray *cmdLine = [brew buildCommandLine:BrewOperationInfo arguments:[NSArray arrayWithObjects:@"git", @"grails", nil]];
  STAssertEquals((NSUInteger)4, cmdLine.count, @"Command line should have 2 items");
  STAssertEqualObjects(@"/usr/local/bin/brew", [cmdLine objectAtIndex:0], @"First item should have been brew executable");
  STAssertEqualObjects(@"info", [cmdLine objectAtIndex:1], @"Second item should have been info");
  STAssertEqualObjects(@"git", [cmdLine objectAtIndex:2], @"Third item should have been git");
  STAssertEqualObjects(@"grails", [cmdLine objectAtIndex:3], @"Fourth item should have been grails");
}

- (void)testBuildCommandLineWithOperationNoneShouldHaveBrewOnly
{
  Brew *brew = [[Brew alloc] initWithDelegate:nil];
  NSArray *cmdLine = [brew buildCommandLine:BrewOperationNone arguments:nil];
  STAssertEquals((NSUInteger)1, cmdLine.count, @"Command line should have 1 item");
  STAssertEqualObjects(@"/usr/local/bin/brew", [cmdLine objectAtIndex:0], @"First item should have been brew executable");
}

@end
