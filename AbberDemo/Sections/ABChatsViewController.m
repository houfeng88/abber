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
    _sessionAry = [[NSMutableArray alloc] init];
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
    NSDictionary *context = [self contextByJid:jid];
    NSMutableArray *messageAry = [context objectForKey:@"messageAry"];
    
    if ( messageAry ) {
      [messageAry addObject:message];
    } else {
      messageAry = [[NSMutableArray alloc] init];
      [messageAry addObject:message];
      [_sessionAry addObject:@{ @"jid":jid, @"messageAry":messageAry }];
    }
    
    [_tableView reloadData];
  }
}

- (NSDictionary *)contextByJid:(NSString *)jid
{
  if ( TKSNonempty(jid) ) {
    for ( NSDictionary *context in _sessionAry ) {
      if ( [jid isEqualToString:[context objectForKey:@"jid"]] ) {
        return context;
      }
    }
  }
  return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_sessionAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABStaticCell *cell = (ABStaticCell *)[tableView dequeueReusableCellWithClass:[ABStaticCell class]];
  
  NSDictionary *context = [_sessionAry objectAtIndex:indexPath.row];
  NSString *jid = [context objectForKey:@"jid"];
  
  cell.titleLabel.text = jid;
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
