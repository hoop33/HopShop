//
//  InstalledFormulaeViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/4/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "InstalledFormulaeViewController.h"
#import "HopShopAppDelegate.h"
#import "HopShopConstants.h"
#import "Formula.h"

@interface InstalledFormulaeViewController ()
- (void)updateInstalledFormulae;
@end

@implementation InstalledFormulaeViewController

@synthesize tableView;
@synthesize arrayController;
@synthesize installedFormulae;
@synthesize loading;

- (void)awakeFromNib
{
  loading = YES;
  self.installedFormulae = [NSMutableArray array];
  [self updateInstalledFormulae];
}

- (void)updateInstalledFormulae
{
  loading = YES;
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  [brew list:nil];
}

#pragma mark - BrewDelegate methods

- (void)listDidComplete:(NSArray *)formulae
{
  [installedFormulae removeAllObjects];
  NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:formulae.count];
  for (id formulaName in formulae) {
    Formula *formula = [[Formula alloc] initWithName:formulaName];
    formula.installed = YES;
    [tempArray addObject:formula];
  }
  [arrayController addObjects:tempArray];
  [self.tableView deselectAll:self];
  [arrayController removeSelectedObjects:[arrayController selectedObjects]];
  loading = NO;
}

#pragma mark - NSTableViewDelegate methods

- (void)tableViewSelectionDidChange:(NSNotification *)notification 
{
  if (!loading)
  {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationClearOutput object:nil];
    if ([[arrayController selectedObjects] count] > 0)
    {
      [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFormulaeSelected object:[arrayController selectedObjects]];
    }
  }
}

@end
