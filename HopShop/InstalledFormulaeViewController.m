//
//  InstalledFormulaeViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/4/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "InstalledFormulaeViewController.h"
#import "HopShopAppDelegate.h"

@interface InstalledFormulaeViewController ()
- (void)updateInstalledFormulae;
@end

@implementation InstalledFormulaeViewController

@synthesize tableView;
@synthesize arrayController;
@synthesize installedFormulae;

- (void)awakeFromNib
{
  self.installedFormulae = [NSMutableArray array];
  [self updateInstalledFormulae];
}

- (void)updateInstalledFormulae
{
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  [brew list:nil];
}

#pragma mark - BrewDelegate methods

- (void)listDidComplete:(NSArray *)formulae
{
  [installedFormulae removeAllObjects];
  for (id formula in formulae) {
    [arrayController addObject:[NSDictionary dictionaryWithObject:[formula copy] forKey:@"name"]];
  }
}

- (void)infoDidComplete:(NSString *)output
{
  HopShopAppDelegate *appDelegate = [HopShopAppDelegate delegate];
  [appDelegate clearOutput];
  [appDelegate appendToOutput:output];
}

#pragma mark - NSTableViewDelegate methods

- (void)tableViewSelectionDidChange:(NSNotification *)notification 
{
  NSArray *selectedFormulae = [arrayController selectedObjects];
  if (selectedFormulae.count > 0) 
  {
    NSMutableArray *formulae = [NSMutableArray arrayWithCapacity:selectedFormulae.count];
    for (NSDictionary *dictionary in selectedFormulae)
    {
      [formulae addObject:[dictionary objectForKey:@"name"]];
    }
    Brew *brew = [[Brew alloc] initWithDelegate:self];
    [brew info:formulae];
  }
}

@end
