//
//  TKTableViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKTableViewController.h"

@implementation TKTableViewController

- (id)init
{
  self = [super init];
  if (self) {
    _tableView = [[TKTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super init];
  if (self) {
    _tableView = [[TKTableView alloc] initWithFrame:CGRectZero style:style];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [_contentView addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [_tableView deselectAllRowsAnimated:YES];
}

- (void)layoutViews
{
  [super layoutViews];
  _tableView.frame = _contentView.bounds;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

@end
