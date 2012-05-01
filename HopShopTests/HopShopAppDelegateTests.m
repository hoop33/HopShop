//
//  HopShopAppDelegateTests.m
//  HopShop
//
//  Created by Rob Warner on 5/1/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "HopShopAppDelegateTests.h"
#import "HopShopAppDelegate.h"

@implementation HopShopAppDelegateTests

- (void)testAppDelegateShouldNotBeNil
{
  HopShopAppDelegate *delegate = [HopShopAppDelegate delegate];
  STAssertNotNil(delegate, @"Delegate should not be nil");
}

- (void)testApplicationDataPathShouldBeCorrect
{
  NSString *path = [[HopShopAppDelegate delegate] pathForAppData];
  NSString *pathCorrect = [@"~/Library/Application Support/HopShop/" stringByExpandingTildeInPath];
  STAssertEqualObjects(pathCorrect, path, [NSString stringWithFormat:@"Application Data Path should be %@ but was %@", pathCorrect, path]);
}

- (void)testApplicationDataPathShouldExist
{
  NSString *path = [[HopShopAppDelegate delegate] pathForAppData];
  STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path], [NSString stringWithFormat:@"Path %@ should exist", path]);
}

@end
