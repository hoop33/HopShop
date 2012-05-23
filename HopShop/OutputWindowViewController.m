//
//  OutputWindowViewController.m
//  HopShop
//
//  Created by Rob Warner on 5/5/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import "OutputWindowViewController.h"
#import "HopShopConstants.h"
#import "Formula.h"

@interface OutputWindowViewController ()
- (void)clearOutput:(NSNotification *)notification;
- (void)formulaInfoReceived:(NSNotification *)notification;
- (void)formulaeSelected:(NSNotification *)notification;
- (void)refreshViewWithFormulae;
@end

@implementation OutputWindowViewController

@synthesize outputView;

NSArray *formulae;

- (void)awakeFromNib
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearOutput:) name:NotificationClearOutput object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(formulaeSelected:) name:NotificationFormulaeSelected object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(formulaInfoReceived:) name:NotificationInfoReceived object:nil];
}

- (void)clearOutput:(NSNotification *)notification
{
  [self.outputView setString:@""];
}

- (void)append:(NSString *)text
{
  [self appendAttributedText:[[NSAttributedString alloc] initWithString:text]];
}

- (void)appendAttributedText:(NSAttributedString *)attributedText
{
  if (attributedText != nil)
  {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.outputView.attributedString];
    [attr appendAttributedString:attributedText];
    [self.outputView.textStorage setAttributedString:attr];
  }
}

- (void)formulaInfoReceived:(NSNotification *)notification
{
  [self refreshViewWithFormulae];
}

- (void)formulaeSelected:(NSNotification *)notification
{
  formulae = [notification.object copy];
  [self refreshViewWithFormulae];
}

- (void)refreshViewWithFormulae
{
  if (outputView != nil && formulae != nil)
  {
    [self clearOutput:nil];
    for (Formula *formula in formulae)
    {
      [self appendAttributedText:[formula fancyDescription]];
    }
  }
}

@end
