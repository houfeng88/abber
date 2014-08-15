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

- (void)layoutViews
{
  [super layoutViews];
  
  _presentedViewController.view.frame = _contentView.bounds;
  
}


- (void)presentWithViewController:(UIViewController *)vc
{
  if ( _presentedViewController ) {
    [_contentView.layer addAnimation:[CATransition pushTransition] forKey:@"push"];
    [self dismissChildViewController:_presentedViewController];
  }
  [self presentChildViewController:vc inView:_contentView];
  _presentedViewController = vc;
  
  [self layoutViews];
}

- (void)dismissByViewController:(UIViewController *)vc
{
  if ( _presentedViewController ) {
    [_contentView.layer addAnimation:[CATransition popTransition] forKey:@"pop"];
    [self dismissChildViewController:_presentedViewController];
  }
  [self presentChildViewController:vc inView:_contentView];
  _presentedViewController = vc;
  
  [self layoutViews];
}

@end
