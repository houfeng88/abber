//
//  ABRootViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABRootViewController.h"
#import "General/CATransitionExtentions.h"

@implementation ABRootViewController

- (id)init
{
  self = [super init];
  if (self) {
    if ( [[[UIDevice currentDevice] systemVersion] floatValue]<7.0 ) {
      self.wantsFullScreenLayout = YES;
    }
  }
  return self;
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  [self layoutViews];
}

- (void)layoutViews
{
  _presentedViewController.view.frame = self.view.bounds;
}

- (void)presentWithViewController:(UIViewController *)vc
{
  if ( _presentedViewController ) {
    [self.view.layer addAnimation:[CATransition pushTransition] forKey:@"push"];
    [self dismissChildViewController:_presentedViewController];
  }
  [self presentChildViewController:vc inView:self.view];
  _presentedViewController = vc;
  
  [self layoutViews];
}

- (void)dismissByViewController:(UIViewController *)vc
{
  if ( _presentedViewController ) {
    [self.view.layer addAnimation:[CATransition popTransition] forKey:@"pop"];
    [self dismissChildViewController:_presentedViewController];
  }
  [self presentChildViewController:vc inView:self.view];
  _presentedViewController = vc;
  
  [self layoutViews];
}

@end
