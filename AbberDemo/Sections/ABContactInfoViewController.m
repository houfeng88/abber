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

- (id)initWithContact:(NSDictionary *)contact
{
  self = [super init];
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
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
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
    cell.bodyField.text = [_contact objectForKey:@"memoname"];
    _memonameField = cell.bodyField;
    return cell;
  } else if ( indexPath.row==1 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Jid", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"jid"];
    return cell;
  } else if ( indexPath.row==2 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Relation", @"");
    NSNumber *relation = [_contact objectForKey:@"relation"];
    cell.bodyLabel.text = [[ABEngine sharedObject] relationString:[relation intValue]];
    return cell;
  } else if ( indexPath.row==3 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Nickname", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"nickname"];
    return cell;
  } else if ( indexPath.row==4 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Desc", @"");
    cell.bodyLabel.text = [_contact objectForKey:@"desc"];
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 55.0;
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


- (void)rightButtonClicked:(id)sender
{
  [TKFindFirstResponderInView(self.view) resignFirstResponder];
  
  
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
  
  NSString *memo = _memonameField.text;
  [[ABEngine sharedObject] updateContact:[_contact objectForKey:@"jid"]
                                    name:TKStrOrLater(memo, @"")
                              completion:^(id result, NSError *error) {
                                [MBProgressHUD dismissHUD:self.view
                                              immediately:NO
                                          completionBlock:^{
                                            [self.navigationController popViewControllerAnimated:YES];
                                          }];
                              }];
}

- (void)deleteButtonClicked:(id)sender
{
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
  
  [[ABEngine sharedObject] removeContact:[_contact objectForKey:@"jid"]
                              completion:^(id result, NSError *error) {
                                [MBProgressHUD dismissHUD:self.view
                                              immediately:NO
                                          completionBlock:^{
                                            [self.navigationController popViewControllerAnimated:YES];
                                          }];
                              }];
}

@end
