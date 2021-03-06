//
//  ABContactInfoViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABContactInfoViewController.h"

#import "ABInfoInputCell.h"
#import "ABInfoStaticCell.h"

@implementation ABContactInfoViewController

- (id)initWithContact:(ABContact *)contact
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
    
    _contact = contact;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = NSLocalizedString(@"Info", @"");
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Done", @"");
  
  [self addResignGestureInView:_tableView];
  
  
  UIView *footerView = [[UIView alloc] init];
  footerView.frame = CGRectMake(0.0, 0.0, _tableView.width, 65.0);
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = NSLocalizedString(@"Delete", @"");
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", TKInsets(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
  [footerView addSubview:button];
  
  _tableView.tableFooterView = footerView;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [[ABEngine sharedObject] requestVcard:_contact.jid
                             completion:^(id result, NSError *error) {
                               if ( result ) {
                                 _contact = result;
                                 [_tableView reloadData];
                               }
                             }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row==0 ) {
    ABInfoInputCell *cell = (ABInfoInputCell *)[tableView dequeueReusableCellWithClass:[ABInfoInputCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Memoname", @"");
    cell.bodyField.text = _contact.memoname;
    cell.bodyField.returnKeyType = UIReturnKeyDone;
    cell.bodyField.maxLength = 20;
    _memonameField = cell.bodyField;
    return cell;
  } else if ( indexPath.row==1 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Jid", @"");
    cell.bodyLabel.text = _contact.jid;
    return cell;
  } else if ( indexPath.row==2 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Relation", @"");
    NSMutableString *relation = [[NSMutableString alloc] init];
    if ( TKSNonempty(_contact.subscription) ) {
      [relation appendString:_contact.subscription];
      if ( TKSNonempty(_contact.ask) ) {
        [relation appendString:@"+"];
        [relation appendString:_contact.ask];
      }
    }
    cell.bodyLabel.text = relation;
    return cell;
  } else if ( indexPath.row==3 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Nickname", @"");
    cell.bodyLabel.text = _contact.nickname;
    return cell;
  } else if ( indexPath.row==4 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Desc", @"");
    cell.bodyLabel.text = _contact.desc;
    return cell;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row==0 ) {
    return [ABInfoInputCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==1 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==2 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==3 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==4 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  }
  return 0.0;
}


- (void)rightButtonClicked:(id)sender
{
  [TKFindFirstResponderInView(self.view) resignFirstResponder];
  
  [self HUDStart];

  NSString *jid = _contact.jid;
  NSString *memo = _memonameField.text;

  [[ABEngine sharedObject] updateContact:jid
                                memoname:TKStrOrLater(memo, @"")
                              completion:^(id result, NSError *error) {
                                if ( error ) {
                                  [self HUDNo:NSLocalizedString(@"Change failed", @"")];
                                } else {
                                  [self HUDYes:NO];
                                }
                              }];
}

- (void)deleteButtonClicked:(id)sender
{
  [self HUDStart];

  NSString *jid = _contact.jid;

  [[ABEngine sharedObject] removeContact:jid
                              completion:^(id result, NSError *error) {
                                if ( error ) {
                                  [self HUDNo:NSLocalizedString(@"Delete failed", @"")];
                                } else {
                                  [self HUDYes:YES];
                                }
                              }];
}

@end
