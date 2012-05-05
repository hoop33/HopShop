//
//  AvailableFormulaeViewController.h
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Brew.h"

@interface AvailableFormulaeViewController : NSViewController<BrewDelegate>

@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong) IBOutlet NSSearchField *searchField;
@property (strong) NSMutableArray *availableFormulae;
@property (strong) Brew *brew;

- (IBAction)updateFilter:(id)sender;

@end
