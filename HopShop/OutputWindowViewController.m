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

#import "OutputWindowViewController.h"
#import "HopShopConstants.h"
#import "Formula.h"

@interface OutputWindowViewController ()
- (void)clearOutput:(NSNotification *)notification;
- (void)outputReceived:(NSNotification *)notification;
- (void)formulaInfoReceived:(NSNotification *)notification;
- (void)formulaeSelected:(NSNotification *)notification;
- (void)updateCompleted:(NSNotification *)notification;
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCompleted:) name:NotificationUpdateCompleted object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputReceived:) name:NotificationOutputReceived object:nil];
}

- (void)clearOutput:(NSNotification *)notification
{
  [self.outputView setString:@""];
}

- (void)outputReceived:(NSNotification *)notification
{
  [self append:notification.object];
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

- (void)updateCompleted:(NSNotification *)notification
{
  if (outputView != nil)
  {
    [self clearOutput:nil];
    [self append:[notification.object copy]];
  }
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
