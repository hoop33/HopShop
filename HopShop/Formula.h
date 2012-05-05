//
//  Formula.h
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brew.h"

@interface Formula : NSObject<BrewDelegate>

@property (strong) NSString *name;
@property (strong) NSString *version;
@property (strong) NSString *info;
@property (nonatomic) BOOL installed;
@property (nonatomic) BOOL outdated;

- (id)initWithName:(NSString *)name;

@end
