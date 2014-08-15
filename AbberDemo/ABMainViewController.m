//
//  ABMainViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMainViewController.h"
#import "ABRootViewController.h"
#import "ABSigninViewController.h"

@implementation ABMainViewController

- (void)dealloc
{
  DDLogDebug(@"[client] dealloc main view controller");
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = @"Sign Out";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(signout:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:button];
  button.frame = CGRectMake(10.0, 30.0, 300.0, 40.0);
  
}

- (void)signout:(id)sender
{
  ABRootViewController *root = (ABRootViewController *)(self.parentViewController);
  ABSigninViewController *vc = [[ABSigninViewController alloc] init];
  [root dismissByViewController:vc];
}

@end
