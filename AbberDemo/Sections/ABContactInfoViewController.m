//
//  ABContactInfoViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABContactInfoViewController.h"

#import "ABInfoImageCell.h"
#import "ABInfoInputCell.h"
#import "ABInfoStaticCell.h"

@implementation ABContactInfoViewController

- (id)initWithContact:(NSDictionary *)contact
{
  self = [super init];
  if (self) {
    _contact = contact;
    self.hidesBottomBarWhenPushed = YES;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Info", @"");
  [_navigationView showBackButton];
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
  
  
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(gestureTap:)];
  recognizer.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:recognizer];
}

- (void)gestureTap:(UIGestureRecognizer *)recognizer
{
  [TKFindFirstResponderInView(_tableView) resignFirstResponder];
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
  if ( section==0 ) {
    return 7;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row==0 ) {
    ABInfoImageCell *cell = (ABInfoImageCell *)[tableView dequeueReusableCellWithClass:[ABInfoImageCell class]];
    cell.titleLabel.text = NSLocalizedString(@"avatar", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"avatar"];
    return cell;
  } else if ( indexPath.row==1 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"jid", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"jid"];
    return cell;
  } else if ( indexPath.row==2 ) {
    ABInfoInputCell *cell = (ABInfoInputCell *)[tableView dequeueReusableCellWithClass:[ABInfoInputCell class]];
    cell.titleLabel.text = NSLocalizedString(@"memoname", @"");
    cell.bodyField.text = [_contact objectForKey:@"memoname"];
    return cell;
  } else if ( indexPath.row==3 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"relation", @"");
    int relation = [[_contact objectForKey:@"relation"] intValue];
    if ( relation==ABSubscriptionTypeNone ) {
      cell.bodyLabel.text = NSLocalizedString(@"None", @"");
    } else if ( relation==ABSubscriptionTypeNoneOut ) {
      cell.bodyLabel.text = NSLocalizedString(@"None+Out", @"");
    } else if ( relation==ABSubscriptionTypeTo ) {
      cell.bodyLabel.text = NSLocalizedString(@"To", @"");
    } else if ( relation==ABSubscriptionTypeToIn ) {
      cell.bodyLabel.text = NSLocalizedString(@"To+In", @"");
    } else if ( relation==ABSubscriptionTypeFrom ) {
      cell.bodyLabel.text = NSLocalizedString(@"From", @"");
    } else if ( relation==ABSubscriptionTypeFromOut ) {
      cell.bodyLabel.text = NSLocalizedString(@"From+Out", @"");
    } else if ( relation==ABSubscriptionTypeBoth ) {
      cell.bodyLabel.text = NSLocalizedString(@"Both", @"");
    }
    return cell;
  } else if ( indexPath.row==4 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"nickname", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"nickname"];
    return cell;
  } else if ( indexPath.row==5 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"birthday", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"birthday"];
    return cell;
  } else if ( indexPath.row==6 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"desc", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"desc"];
    return cell;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row==0 ) {
    return [ABInfoImageCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==1 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==2 ) {
    return [ABInfoInputCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==3 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==4 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==5 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==6 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  }
  return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 55.0;
  }
  return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  UIView *footer = [[UIView alloc] init];
  footer.frame = CGRectMake(0.0, 0.0, _tableView.width, 65.0);
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = NSLocalizedString(@"Delete", @"");
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", TKInsets(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
  [footer addSubview:button];
  
  return footer;
}



- (void)deleteButtonClicked:(id)sender
{
  [[ABEngine sharedObject] removeContact:[_contact objectForKey:@"jid"]
                              completion:^(id result, NSError *error) {
                                [self.navigationController popViewControllerAnimated:YES];
                              }];
  [[ABEngine sharedObject] unsubscribeContact:[_contact objectForKey:@"jid"]];
}

@end
