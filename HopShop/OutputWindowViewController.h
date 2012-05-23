//
//  OutputWindowViewController.h
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OutputWindowViewController : NSViewController

@property (strong) IBOutlet NSTextView *outputView;

- (void)append:(NSString *)text;
- (void)appendAttributedText:(NSAttributedString *)attributedText;

@end
