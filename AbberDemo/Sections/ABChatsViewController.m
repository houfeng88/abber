//
//  ABChatsViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABChatsViewController.h"
#import "ABStaticCell.h"

#import "ABSessionViewController.h"

@implementation ABChatsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _navigationView.titleLabel.text = NSLocalizedString(@"Chats", @"");
}


- (void)setSessionManager:(ABSessionManager *)sessionManager
{
  _sessionManager = sessionManager;
  
  _sessionAry = [_sessionManager sessionAry];
  if ( [self viewAppeared] ) {
    [_tableView reloadData];
  }
}

- (void)engine:(ABEngine *)engine didReceiveMessage:(ABMessage *)message
{
  NSString *jid = message.from;
  
  [_sessionManager addSession:jid];
  
  NSMutableArray *messageAry = (NSMutableArray *)[_sessionManager messageAryForJid:jid];
  [messageAry addObject:message];
  
  
  _sessionAry = [_sessionManager sessionAry];
  if ( [self viewAppeared] ) {
    [_tableView reloadData];
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_sessionAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABStaticCell *cell = (ABStaticCell *)[tableView dequeueReusableCellWithClass:[ABStaticCell class]];
  
  NSString *jid = [_sessionAry objectAtIndex:indexPath.row];
  cell.titleLabel.text = jid;
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  NSDictionary *context = [_sessionAry objectAtIndex:indexPath.row];
//  ABSessionViewController *vc = [[ABSessionViewController alloc] initWithContext:context];
//  [self.navigationController pushViewController:vc animated:YES];
}

@end
