//
//  ABFriendsViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABFriendsViewController.h"
#import "ABContactCell.h"

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
  _contactAry = [[TKDatabase sharedObject] executeQuery:@"SELECT * FROM contact;"];
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
  
  TKDatabaseRow *row = [_contactAry objectAtIndex:indexPath.row];
  cell.nicknameLabel.text = [row stringForName:@"nickname"];
  cell.descLabel.text = [row stringForName:@"desc"];
  
  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [ABContactCell heightForTableView:tableView object:nil];
}

@end