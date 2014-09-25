//
//  ABUserInfoViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABUserInfoViewController.h"

@implementation ABUserInfoViewController

- (id)init
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = NSLocalizedString(@"Info", @"");
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Done", @"");
}

@end
