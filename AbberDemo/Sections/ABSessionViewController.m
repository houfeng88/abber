//
//  ABSessionViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 9/29/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSessionViewController.h"
#import "ABMessageCell.h"

@implementation ABSessionViewController

- (id)initWithContext:(NSDictionary *)context
{
  self = [super init];
  if (self) {
    [[ABEngine sharedObject] addObserver:self];
    _context = context;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
}


- (void)engine:(ABEngine *)engine didReceiveMessage:(ABMessage *)message
{
  [_tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray *messageAry = [_context objectForKey:@"messageAry"];
  return [messageAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray *messageAry = [_context objectForKey:@"messageAry"];
  ABMessage *message = [messageAry objectAtIndex:indexPath.row];
  
  
  ABMessageCell *cell = (ABMessageCell *)[tableView dequeueReusableCellWithClass:[ABMessageCell class]];
  
  cell.titleLabel.text = message.from;
  cell.bodyLabel.text = message.content;
  
  [cell updateReceived:TKSNonempty(message.from)];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray *messageAry = [_context objectForKey:@"messageAry"];
  ABMessage *message = [messageAry objectAtIndex:indexPath.row];
  
  return [ABMessageCell heightForTableView:tableView object:message.content];
}

@end
