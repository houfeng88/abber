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
  
  
  _tableView = [[TKTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self loadContacts];
  [self refreshContacts];
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
    
    [self loadContacts];
    [self refreshContacts];
    [_tableView.initialRefreshControl endRefreshing];
    
  }];
}

- (void)loadContacts
{
  FMDatabaseQueue *database = [[ABEngine sharedObject] database];
  [database inDatabase:^(FMDatabase *db) {
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM contact;"];
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    while ( [rs next] ) {
      NSString *jid = [rs stringForColumn:@"jid"];
      NSString *memoname = [rs stringForColumn:@"memoname"];
      int relation = [rs intForColumn:@"relation"];
      NSString *nickname = [rs stringForColumn:@"nickname"];
      NSString *avatar = [rs stringForColumn:@"avatar"];
      NSString *birthday = [rs stringForColumn:@"birthday"];
      NSString *desc = [rs stringForColumn:@"desc"];
      
      NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
      [contact setObject:jid forKeyIfNotNil:@"jid"];
      [contact setObject:memoname forKeyIfNotNil:@"memoname"];
      [contact setObject:@(relation) forKeyIfNotNil:@"relation"];
      [contact setObject:nickname forKeyIfNotNil:@"nickname"];
      [contact setObject:avatar forKeyIfNotNil:@"avatar"];
      [contact setObject:birthday forKeyIfNotNil:@"birthday"];
      [contact setObject:desc forKeyIfNotNil:@"desc"];
      [ary addObject:contact];
    }
    _contactAry = ary;
  }];
}

- (void)refreshContacts
{
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
  NSString *memoname = [contact objectForKey:@"memoname"];
  NSNumber *relation = [contact objectForKey:@"relation"];
  NSString *nickname = [contact objectForKey:@"nickname"];
  NSString *desc = [contact objectForKey:@"desc"];
  
  
  NSString *name = TKStrOrLater(memoname, nickname);
  
  //cell.avatarView.image = nil;
  cell.nicknameLabel.text = TKStrOrLater(name, jid);
  cell.statusLabel.text = nil;
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
