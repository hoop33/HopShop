//
//  InstalledFormulaeViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/4/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "InstalledFormulaeViewController.h"

@interface InstalledFormulaeViewController ()
- (void)updateInstalledFormulae;
@end

@implementation InstalledFormulaeViewController

@synthesize tableView;
@synthesize arrayController;
@synthesize installedFormulae;
@synthesize brew;

- (void)awakeFromNib
{
  self.installedFormulae = [NSMutableArray array];
  self.brew = [[Brew alloc] initWithDelegate:self];
  [self updateInstalledFormulae];
}

- (void)updateInstalledFormulae
{
  [brew list:nil];
}

- (void)listDidComplete:(NSArray *)formulae
{
  [installedFormulae removeAllObjects];
  for (id formula in formulae) {
    [installedFormulae addObject:[NSDictionary dictionaryWithObject:formula forKey:@"name"]];
  }
  NSLog(@"%@", installedFormulae);
  [self.tableView reloadData];
}

@end
