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

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = NSLocalizedString(@"Add", @"");
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Done", @"");
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [_contentView addSubview:_tableView];
}

- (void)layoutViews
{
  [super layoutViews];
  _tableView.frame = _contentView.bounds;
}




- (void)rightButtonClicked:(id)sender
{
//  [[ABEngine sharedObject] addContact:_accountField.text
//                                 name:_memonameField.text
//                           completion:^(id result, NSError *error) {
//                             NSLog(@"add complete");
//                           }];
//  [[ABEngine sharedObject] subscribeContact:_accountField.text];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 2;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABInputCell *cell = (ABInputCell *)[tableView dequeueReusableCellWithClass:[ABInputCell class]];
  if ( indexPath.row==0 ) {
    cell.titleLabel.text = NSLocalizedString(@"Account:", @"");
    cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.valueField.returnKeyType = UIReturnKeyNext;
    cell.valueField.delegate = self;
    _accountField = cell.valueField;
  } else if ( indexPath.row==1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Memoname:", @"");
    cell.valueField.returnKeyType = UIReturnKeyDone;
    cell.valueField.delegate = self;
    _memonameField = cell.valueField;
  }
  return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ( textField==_accountField ) {
    [_memonameField becomeFirstResponder];
  } else if ( textField==_memonameField ) {
    [textField resignFirstResponder];
  }
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return (([textField.text length] + [string length] - range.length)<=40);
}

@end
