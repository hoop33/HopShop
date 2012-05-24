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

#import "AvailableFormulaeViewController.h"
#import "HopShopAppDelegate.h"
#import "HopShopConstants.h"
#import "Formula.h"

#define kAvailableFormulaeFile @"available_formulae.plist"

@interface AvailableFormulaeViewController ()
- (void)updateAvailableFormulae;
@end

@implementation AvailableFormulaeViewController

@synthesize tableView;
@synthesize arrayController;
@synthesize searchField;
@synthesize availableFormulae;
@synthesize loading;

NSPredicate *formulaePredicate;

- (void)awakeFromNib
{
  loading = YES;
  
  // Set up search
  formulaePredicate = [NSPredicate predicateWithFormat:@"name beginswith[cd] $searchString"];
  
  // Read in stored list
  NSData *formulaeData = [[NSData alloc] initWithContentsOfFile:[[[HopShopAppDelegate delegate] pathForAppData] stringByAppendingPathComponent:kAvailableFormulaeFile]];
  if (formulaeData != nil)
  {
    self.availableFormulae = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:formulaeData]];
  }
  if (availableFormulae == nil) {
    self.availableFormulae = [NSMutableArray array];
  }
  [self updateAvailableFormulae];
}

- (void)updateAvailableFormulae
{
  loading = YES;
  Brew *brew = [[Brew alloc] initWithDelegate:self];
  [brew search:nil];
}

#pragma mark - BrewDelegate methods

- (void)searchDidComplete:(NSArray *)formulae
{
  [availableFormulae removeAllObjects];
  NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:formulae.count];
  for (id formulaName in formulae) {
    Formula *formula = [[Formula alloc] initWithName:formulaName];
    [tempArray addObject:formula];
  }
  [arrayController addObjects:tempArray];
  NSData *formulaeData = [NSKeyedArchiver archivedDataWithRootObject:[arrayController arrangedObjects]];
  [formulaeData writeToFile:[[[HopShopAppDelegate delegate] pathForAppData] stringByAppendingPathComponent:kAvailableFormulaeFile] atomically:YES];
  [self.tableView deselectAll:self];
  [arrayController removeSelectedObjects:[arrayController selectedObjects]];
  loading = NO;
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
