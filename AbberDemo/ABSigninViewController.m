//
//  ABSigninViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSigninViewController.h"
#import "ABRootViewController.h"
#import "ABMainViewController.h"

@implementation ABSigninViewController

- (void)dealloc
{
  DDLogDebug(@"[client] dealloc signin view controller");
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = @"Sign In";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(signin:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:button];
  button.frame = CGRectMake(10.0, 30.0, 300.0, 40.0);
  
  _navigationView.titleLabel.text = @"Sign in";
}

- (void)signin:(id)sender
{
  ABRootViewController *root = (ABRootViewController *)(self.parentViewController);
  ABMainViewController *vc = [[ABMainViewController alloc] init];
  [root presentWithViewController:vc];
}

@end
