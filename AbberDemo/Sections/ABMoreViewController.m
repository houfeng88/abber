//
//  ABMoreViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMoreViewController.h"
#import "ABStaticCell.h"

#import "ABSigninViewController.h"


#import "ABUserInfoViewController.h"
#import "ABUserStatusViewController.h"

#import "ABAboutViewController.h"

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



- (void)setSessionManager:(ABSessionManager *)manager
{
  _sessionManager = manager;
}


- (void)signoutButtonClicked:(id)sender
{
  [[ABEngine sharedObject] disconnect];
  
  UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  window.rootViewController = [[ABSigninViewController alloc] init];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 2;
  } else if ( section==1 ) {
    return 1;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABStaticCell *cell = (ABStaticCell *)[tableView dequeueReusableCellWithClass:[ABStaticCell class]];
  
  if ( indexPath.section==0 ) {
    if ( indexPath.row==0 ) {
      cell.titleLabel.text = NSLocalizedString(@"Profile", @"");
    } else if ( indexPath.row==1 ) {
      cell.titleLabel.text = NSLocalizedString(@"Status", @"");
    }
  } else if ( indexPath.section==1 ) {
    if ( indexPath.row==0 ) {
      cell.titleLabel.text = NSLocalizedString(@"About", @"");
    }
  }
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.section==0 ) {
    if ( indexPath.row==0 ) {
      ABUserInfoViewController *vc = [[ABUserInfoViewController alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    } else if ( indexPath.row==1 ) {
      ABUserStatusViewController *vc = [[ABUserStatusViewController alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }
  } else if ( indexPath.section==1 ) {
    if ( indexPath.row==0 ) {
      ABAboutViewController *vc = [[ABAboutViewController alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }
  }
}

@end
