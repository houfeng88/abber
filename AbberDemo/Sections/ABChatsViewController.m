//
//  ABChatsViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABChatsViewController.h"
#import "ABStaticCell.h"

@implementation ABChatsViewController

- (id)init
{
  self = [super init];
  if (self) {
    _sessionMap = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _navigationView.titleLabel.text = NSLocalizedString(@"Chats", @"");
}


- (void)engine:(ABEngine *)engine didReceiveMessage:(ABMessage *)message
{
  NSString *jid = message.from;
  if ( TKSNonempty(jid) ) {
    NSMutableArray *messageAry = [_sessionMap objectForKey:jid];
    if ( messageAry ) {
      [messageAry addObject:message];
    } else {
      messageAry = [[NSMutableArray alloc] init];
      [messageAry addObject:message];
      [_sessionMap setObject:messageAry forKey:jid];
    }
    
    [_tableView reloadData];
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[_sessionMap allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABStaticCell *cell = (ABStaticCell *)[tableView dequeueReusableCellWithClass:[ABStaticCell class]];
  
  cell.titleLabel.text = [[_sessionMap allKeys] objectAtIndex:indexPath.row];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
