//
//  ABUserStatusViewController.m
//  AbberDemo
//
//  Created by Kevin on 10/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABUserStatusViewController.h"
#import "ABStaticCell.h"

@implementation ABUserStatusViewController

- (id)init
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
    _statusAry = @[
                   ABPresenceAvailable,
                   ABPresenceChat,
                   ABPresenceAway,
                   ABPresenceDND,
                   ABPresenceXA
                   ];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = NSLocalizedString(@"Status", @"");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_statusAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABStaticCell *cell = (ABStaticCell *)[tableView dequeueReusableCellWithClass:[ABStaticCell class]];
  
  ABContact *user = [[ABEngine sharedObject] user];
  NSString *status = [_statusAry objectAtIndex:indexPath.row];
  cell.titleLabel.text = status;
  if ( [status isEqualToString:user.status] ) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [[ABEngine sharedObject] updatePresence:[_statusAry objectAtIndex:indexPath.row]];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
