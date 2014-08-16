//
//  ABMoreViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMoreViewController.h"

@implementation ABMoreViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Sign Out", @"");
}

@end
