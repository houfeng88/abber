//
//  ABFriendsViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABFriendsViewController.h"
#import "ABContactCell.h"

#import "ABAddContactViewController.h"

#import "ABContactInfoViewController.h"

@implementation ABFriendsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Friends", @"");
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Add", @"");
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  _contactAry = [[ABEngine sharedObject] contacts];
  [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  @weakify(self);
  [_tableView addInitialRefreshControlWithRefreshBlock:^{
    @strongify(self);
    [self requestContacts];
  }];
}



- (void)rightButtonClicked:(id)sender
{
  ABAddContactViewController *vc = [[ABAddContactViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}


- (void)requestContacts
{
  [[ABEngine sharedObject] requestRosterWithCompletion:^(id result, NSError *error) {
    
    _contactAry = [[ABEngine sharedObject] contacts];
    [_tableView reloadData];
    [_tableView.initialRefreshControl endRefreshing];
    
  }];
}


- (void)engine:(ABEngine *)engine didReceiveRosterUpdate:(NSDictionary *)item
{
  _contactAry = [[ABEngine sharedObject] contacts];
  [_tableView reloadData];
}

- (void)engine:(ABEngine *)engine didReceivePresence:(int)presence contact:(NSString *)jid
{
  _contactAry = [[ABEngine sharedObject] contacts];
  [_tableView reloadData];
}

- (void)engine:(ABEngine *)engine didReceiveVcard:(NSDictionary *)vcard error:(NSError *)error
{
  _contactAry = [[ABEngine sharedObject] contacts];
  [_tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_contactAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABContactCell *cell = (ABContactCell *)[tableView dequeueReusableCellWithClass:[ABContactCell class]];
  
  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  
  NSDictionary *contact = [_contactAry objectAtIndex:indexPath.row];
  NSString *jid = [contact objectForKey:@"jid"];
  NSNumber *status = [contact objectForKey:@"status"];
  NSString *memoname = [contact objectForKey:@"memoname"];
  //NSNumber *relation = [contact objectForKey:@"relation"];
  NSString *nickname = [contact objectForKey:@"nickname"];
  NSString *desc = [contact objectForKey:@"desc"];
  
  
  NSString *name = TKStrOrLater(memoname, nickname);
  
  //cell.avatarView.image = nil;
  cell.nicknameLabel.text = TKStrOrLater(name, jid);
  cell.statusLabel.text = [[ABEngine sharedObject] statusString:[status intValue]];
  cell.descLabel.text = desc;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [ABContactCell heightForTableView:tableView object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *contact = [_contactAry objectAtIndex:indexPath.row];
  ABContactInfoViewController *vc = [[ABContactInfoViewController alloc] initWithContact:contact];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
