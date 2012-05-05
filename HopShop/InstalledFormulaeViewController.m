//
//  InstalledFormulaeViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/4/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "InstalledFormulaeViewController.h"
#import "HopShopAppDelegate.h"
#import "Formula.h"

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
  NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:formulae.count];
  for (id formulaName in formulae) {
    Formula *formula = [[Formula alloc] initWithName:formulaName];
    formula.installed = YES;
    [tempArray addObject:formula];
  }
  [arrayController addObjects:tempArray];
}

#pragma mark - NSTableViewDelegate methods

- (void)tableViewSelectionDidChange:(NSNotification *)notification 
{
  HopShopAppDelegate *appDelegate = [HopShopAppDelegate delegate];
  [appDelegate clearOutput];
  NSArray *selectedFormulae = [arrayController selectedObjects];
  if (selectedFormulae.count > 0) 
  {
    for (Formula *formula in selectedFormulae)
    {
      [appDelegate appendToOutput:[NSString stringWithFormat:@"%@ %@\n", formula.name, formula.version]];
      [appDelegate appendToOutput:formula.info];
      [appDelegate appendToOutput:@"\n"]; 
    }
  }
}

@end
