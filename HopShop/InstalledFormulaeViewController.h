//
//  InstalledFormulaeViewController.h
//  HopShop
//
//  Created by Rob Warner on 5/4/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Brew.h"

@interface InstalledFormulaeViewController : NSViewController<BrewDelegate, NSTableViewDelegate>

@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong) NSMutableArray *installedFormulae;
@property (assign) BOOL loading;

@end
