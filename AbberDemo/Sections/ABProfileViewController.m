//
//  ABProfileViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/18/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABProfileViewController.h"

@implementation ABProfileViewController

- (id)initWithContact:(TKDatabaseRow *)contact
{
  self = [super init];
  if (self) {
    _row = contact;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Profile", @"");
  [_navigationView showBackButton];
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
  
  
  _headerView = [[UIView alloc] init];
  _headerView.backgroundColor = [UIColor redColor];
  _headerView.frame = CGRectMake(0.0, 0.0, 320.0, 100.0);
  
  _tableView.tableHeaderView = _headerView;
  
  
  _footerView = [[UIView alloc] init];
  _footerView.frame = CGRectMake(0.0, 0.0, 320.0, 65.0);
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = NSLocalizedString(@"Delete", @"");
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 10.0, 300.0, 45.0);
  [_footerView addSubview:button];
  
  _tableView.tableFooterView = _footerView;
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
}



- (void)deleteButtonClicked:(id)sender
{
//  [[ABEngine sharedObject] removeContact:[_row stringForName:@"jid"]
//                              completion:^(id result, NSError *error) {
//                                NSLog(@"remove complete");
//                              }];
//  
//  [[ABEngine sharedObject] unsubscribeContact:[_row stringForName:@"jid"]];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 2;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithClass:[UITableViewCell class]];
  return cell;
}

@end
