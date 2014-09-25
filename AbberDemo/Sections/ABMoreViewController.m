//
//  ABMoreViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMoreViewController.h"

#import "ABMainViewController.h"

@implementation ABMoreViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _navigationView.titleLabel.text = NSLocalizedString(@"More", @"");
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Sign Out", @"");
}


- (void)rightButtonClicked:(id)sender
{
  [[ABEngine sharedObject] disconnect];
  
  ABMainViewController *main = (ABMainViewController *)([self tabBarController]);
  [main presentSignin];
}

@end
