//
//  Brew.h
//  HopShop
//
//  Created by Rob Warner on 5/1/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskWrapper.h"

@protocol BrewDelegate<NSObject>

@optional
- (void)listDidComplete:(NSArray *)formulae;
- (void)searchDidComplete:(NSArray *)formulae;
- (void)installDidComplete:(NSString *)output;
- (void)uninstallDidComplete:(NSString *)output;
- (void)updateDidComplete:(NSString *)output;
- (void)upgradeDidComplete:(NSString *)output;
- (void)infoDidComplete:(NSString *)output;
- (void)outdatedDidComplete:(NSArray *)formulae;
- (void)appendOutput:(NSString *)output;
- (void)processStarted;
- (void)processFinished:(NSString *)output;
@end

typedef enum {
  BrewOperationNone = 0,
  BrewOperationList,
  BrewOperationSearch,
  BrewOperationInfo,
  BrewOperationUpdate,
  BrewOperationUpgrade,
  BrewOperationInstall,
  BrewOperationUninstall,
  BrewOperationOutdated
} BrewOperation;
@interface Brew : NSObject<TaskWrapperController>

@property (nonatomic) BOOL isRunning;
@property (nonatomic) BrewOperation currentOperation;
@property (strong) NSString *currentOutput;
@property (strong) id<BrewDelegate> delegate;
@property (strong) TaskWrapper *brewTask;

- (id)initWithDelegate:(id<BrewDelegate>)delegate;
- (void)search:(NSString *)searchString;
- (void)list:(NSArray *)formulae;
- (void)install:(NSArray *)formulae;
- (void)uninstall:(NSArray *)formulae;
- (void)update;
- (void)upgrade:(NSArray *)formulae;
- (void)info:(NSArray *)formulae;
- (void)outdated;

- (NSArray *)buildCommandLine:(BrewOperation)operation arguments:(NSArray *)arguments;

@end
