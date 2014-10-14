//
//  ABAboutViewController.m
//  AbberDemo
//
//  Created by Kevin on 10/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABAboutViewController.h"

@implementation ABAboutViewController

- (id)init
{
  self = [super init];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = NSLocalizedString(@"About", @"");
}

@end
