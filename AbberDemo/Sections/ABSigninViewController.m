//
//  ABSigninViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSigninViewController.h"
#import "General/ABInputCell.h"

#import "ABRootViewController.h"

#import "ABMainViewController.h"

@implementation ABSigninViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.titleLabel.text = @"Abber";
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  _tableView.delegate = self;
  _tableView.dataSource = self;
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
    return 2;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABInputCell *cell = (ABInputCell *)[tableView dequeueReusableCellWithClass:[ABInputCell class]];
  if ( indexPath.row==0 ) {
    cell.titleLabel.text = NSLocalizedString(@"Account:", @"");
    cell.valueField.text = [[TKSettings sharedObject] objectForKey:@"ABSavedAccountKey"];
    cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.valueField.returnKeyType = UIReturnKeyNext;
    cell.valueField.delegate = self;
    _accountField = cell.valueField;
  } else if ( indexPath.row==1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Password:", @"");
    cell.valueField.text = [[TKSettings sharedObject] objectForKey:@"ABSavedPasswordKey"];
    cell.valueField.secureTextEntry = YES;
    cell.valueField.returnKeyType = UIReturnKeyDone;
    cell.valueField.delegate = self;
    _passwordField = cell.valueField;
  }
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 55.0;
  }
  return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return [[UIView alloc] init];
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
  footer.frame = CGRectMake(0.0, 0.0, _tableView.width, 55.0);
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = NSLocalizedString(@"Sign In", @"");
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", TKInsets(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(signinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
  [footer addSubview:button];
  
  return footer;
}



- (void)signinButtonClicked:(id)sender
{
  if ( [self checkValidity] ) {
    [self signin];
  }
}

- (BOOL)checkValidity
{
  NSString *acnt = _accountField.text;
  NSString *pswd = _passwordField.text;
  
  if ( !TKSNonempty(acnt) ) {
    TKPresentSystemMessage(NSLocalizedString(@"Invalid account", @""));
    return NO;
  }
  
  if ( !TKSNonempty(pswd) ) {
    TKPresentSystemMessage(NSLocalizedString(@"Invalid password", @""));
    return NO;
  }
  
  return YES;
}

- (void)signin
{
  NSString *acnt = _accountField.text;
  NSString *pswd = _passwordField.text;
  
  [[TKSettings sharedObject] setObject:acnt forKey:@"ABSavedAccountKey"];
  [[TKSettings sharedObject] setObject:pswd forKey:@"ABSavedPasswordKey"];
  [[TKSettings sharedObject] synchronize];
  
  
  ABEngine *engine = [[ABEngine alloc] init];
  [ABEngine saveObject:engine];
  
  [engine addObserver:self];
  [engine addObserver:[[UIApplication sharedApplication] delegate]];
  [engine prepare];
  [engine connectWithAccount:acnt password:pswd];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ( textField==_accountField ) {
    [_passwordField becomeFirstResponder];
  } else if ( textField==_passwordField ) {
    [textField resignFirstResponder];
  }
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return (([textField.text length] + [string length] - range.length)<=15);
}



- (void)engineDidStartConnecting:(ABEngine *)engine
{
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
}

- (void)engine:(ABEngine *)engine didReceiveConnectStatus:(BOOL)status
{
  if ( status ) {
    
    [[ABEngine sharedObject] requestRosterWithCompletion:^(id result, NSError *error) {
      
      if ( error ) {
        [MBProgressHUD presentTextHUD:self.view
                                 info:NSLocalizedString(@"Sign in failed", @"")
                              offsetY:0.0
                      completionBlock:NULL];
        [engine disconnect];
      } else {
        [[ABEngine sharedObject] removeObserver:self];
        
        [[ABEngine sharedObject] updatePresence:ABPresenceTypeAvailable];
        
        [MBProgressHUD dismissHUD:self.view
                      immediately:NO
                  completionBlock:^{
                    ABRootViewController *root = (ABRootViewController *)(self.parentViewController);
                    ABMainViewController *vc = [[ABMainViewController alloc] init];
                    [root presentWithViewController:vc];
                  }];
      }
    
    }];
    
  } else {
    [MBProgressHUD presentTextHUD:self.view
                             info:NSLocalizedString(@"Sign in failed", @"")
                          offsetY:0.0
                  completionBlock:NULL];
  }
}

- (void)engineDidDisconnected:(ABEngine *)engine
{
  [MBProgressHUD presentTextHUD:self.view
                           info:NSLocalizedString(@"Sign in failed", @"")
                        offsetY:0.0
                completionBlock:NULL];
}

@end
