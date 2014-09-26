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
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Sign Out", @"");
}


- (void)rightButtonClicked:(id)sender
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
