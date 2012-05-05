//
//  AvailableFormulaeViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "AvailableFormulaeViewController.h"
#import "HopShopAppDelegate.h"

#define kAvailableFormulaeFile @"available_formulae.plist"

@interface AvailableFormulaeViewController ()
- (void)updateAvailableFormulae;
@end

@implementation AvailableFormulaeViewController

@synthesize tableView;
@synthesize arrayController;
@synthesize searchField;
@synthesize availableFormulae;
@synthesize brew;

NSPredicate *formulaePredicate;

- (void)awakeFromNib
{
  // Set up search
  formulaePredicate = [NSPredicate predicateWithFormat:@"name beginswith[cd] $searchString"];

  // Read in stored list
  HopShopAppDelegate *delegate = [HopShopAppDelegate delegate];
  self.availableFormulae = [[NSMutableArray alloc] initWithContentsOfFile:[[delegate pathForAppData] stringByAppendingPathComponent:kAvailableFormulaeFile]];
  if (availableFormulae == nil) {
    self.availableFormulae = [[NSMutableArray alloc] init];
  }

  self.brew = [[Brew alloc] initWithDelegate:self];

  [self updateAvailableFormulae];
}

- (void)updateAvailableFormulae
{
  [brew search:nil];
}

#pragma mark - BrewDelegate methods

- (void)searchDidComplete:(NSArray *)formulae
{
  [availableFormulae removeAllObjects];
  for (id formula in formulae) {
    [availableFormulae addObject:[NSDictionary dictionaryWithObject:formula forKey:@"name"]];
  }
  [availableFormulae writeToFile:[[[HopShopAppDelegate delegate] pathForAppData] stringByAppendingPathComponent:kAvailableFormulaeFile] atomically:YES];
  [self.tableView reloadData];
}

- (void)infoDidComplete:(NSString *)output
{
  HopShopAppDelegate *appDelegate = [HopShopAppDelegate delegate];
  [appDelegate clearOutput];
  [appDelegate appendToOutput:output];
}

#pragma mark - Action methods

- (IBAction)updateFilter:(id)sender {
  NSString *searchString = [searchField stringValue];
  NSPredicate *predicate = nil;
  if (![searchString isEqualToString:@""]) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:searchString forKey:@"searchString"];
    predicate = [formulaePredicate predicateWithSubstitutionVariables:dictionary];
  }
  [arrayController setFilterPredicate:predicate];
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
    [brew info:formulae];
  }
}


@end
