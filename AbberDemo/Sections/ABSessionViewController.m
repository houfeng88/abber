//
//  ABSessionViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 9/29/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSessionViewController.h"

@implementation ABSessionViewController

- (id)initWithContact:(ABContact *)contact
{
  self = [super init];
  if (self) {
    _contact = contact;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = TKStrOrLater(_contact.memoname, _contact.nickname);
}

@end
