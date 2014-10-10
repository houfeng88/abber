//
//  ABMoreViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMoreViewController.h"

#import "ABMainViewController.h"

#import "ABUserInfoViewController.h"

@implementation ABMoreViewController

- (id)init
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _navigationView.titleLabel.text = NSLocalizedString(@"More", @"");
  
  
  UIView *footerView = [[UIView alloc] init];
  footerView.frame = TKRect(0.0, 0.0, _tableView.width, 55.0);
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = NSLocalizedString(@"Sign Out", @"");
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", TKInsets(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(signoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
  [footerView addSubview:button];
  
  _tableView.tableFooterView = footerView;
}


- (void)signoutButtonClicked:(id)sender
{
  [[ABEngine sharedObject] disconnect];
  
  ABMainViewController *main = (ABMainViewController *)([self tabBarController]);
  [main presentSignin];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithClass:[UITableViewCell class]];
  
  NSInteger row = indexPath.row;
  
  if ( row==0 ) {
    cell.textLabel.text = NSLocalizedString(@"Profile", @"");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger row = indexPath.row;
  
  if ( row==0 ) {
    ABUserInfoViewController *vc = [[ABUserInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

@end
