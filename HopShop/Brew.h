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
- (void)outputReceived:(NSString *)output;
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
