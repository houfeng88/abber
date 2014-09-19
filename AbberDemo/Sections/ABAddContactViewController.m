//
//  ABAddContactViewController.m
//  AbberDemo
//
//  Created by Kevin on 8/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABAddContactViewController.h"
#import "ABInputCell.h"

@implementation ABAddContactViewController

- (id)init
{
  self = [super init];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = NSLocalizedString(@"Add", @"");
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Done", @"");
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABInputCell *cell = (ABInputCell *)[tableView dequeueReusableCellWithClass:[ABInputCell class]];
  if ( indexPath.row==0 ) {
    cell.titleLabel.text = NSLocalizedString(@"Account:", @"");
    cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.valueField.returnKeyType = UIReturnKeyNext;
    cell.valueField.maxLength = 20;
    _accountField = cell.valueField;
  } else if ( indexPath.row==1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Memoname:", @"");
    cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.valueField.returnKeyType = UIReturnKeyDone;
    cell.valueField.maxLength = 20;
    _memonameField = cell.valueField;
  }
  [(TKTextField *)_accountField setNextField:_memonameField];
  [(TKTextField *)_memonameField setNextField:nil];
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  return [[UIView alloc] init];
}



- (void)rightButtonClicked:(id)sender
{
  [TKFindFirstResponderInView(self.view) resignFirstResponder];
  
  if ( [self checkValidity] ) {
    [self add];
  }
}


- (BOOL)checkValidity
{
  NSString *acnt = _accountField.text;
  NSString *memo = _memonameField.text;
  
  if ( !TKSNonempty(acnt) ) {
    TKPresentSystemMessage(NSLocalizedString(@"Invalid account", @""));
    return NO;
  }
  
  if ( !TKSNonempty(memo) ) {
    TKPresentSystemMessage(NSLocalizedString(@"Invalid memoname", @""));
    return NO;
  }
  
  return YES;
}

- (void)add
{
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
  
  
  NSString *acnt = _accountField.text;
  NSString *memo = _memonameField.text;
  
  [[ABEngine sharedObject] addContact:acnt
                                 name:memo
                           completion:^(id result, NSError *error) {
                             [MBProgressHUD dismissHUD:self.view
                                           immediately:NO
                                       completionBlock:^{
                                         [self.navigationController popViewControllerAnimated:YES];
                                       }];
                           }];
  [[ABEngine sharedObject] subscribeContact:acnt];
}

@end
