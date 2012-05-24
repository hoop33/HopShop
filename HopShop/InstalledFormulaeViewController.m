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
