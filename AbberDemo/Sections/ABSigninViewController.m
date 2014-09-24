//
//  ABSigninViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSigninViewController.h"
#import "ABInputCell.h"

#import "ABMainViewController.h"

@implementation ABSigninViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.titleLabel.text = @"Abber";
  
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
    cell.valueField.text = [[TKSettings sharedObject] objectForKey:@"ABSavedAccountKey"];
    cell.valueField.returnKeyType = UIReturnKeyNext;
    cell.valueField.maxLength = 20;
    _accountField = cell.valueField;
  } else if ( indexPath.row==1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Password:", @"");
    cell.valueField.text = [[TKSettings sharedObject] objectForKey:@"ABSavedPasswordKey"];
    cell.valueField.returnKeyType = UIReturnKeyDone;
    cell.valueField.secureTextEntry = YES;
    cell.valueField.maxLength = 20;
    _passwordField = cell.valueField;
  }
  [(TKTextField *)_accountField setNextField:_passwordField];
  [(TKTextField *)_passwordField setNextField:nil];
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 55.0;
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
  [TKFindFirstResponderInView(self.view) resignFirstResponder];
  
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
  
  
  ABEngine *engine = [ABEngine sharedObject];
  [engine removeAllObservers];
  
  engine = [[ABEngine alloc] init];
  [ABEngine saveObject:engine];
  
  [engine addObserver:self];
  
  UITabBarController *main = (UITabBarController *)(self.parentViewController);
  [engine addObserver:main];
  for ( UINavigationController *vc in main.viewControllers ) {
    if ( [vc isKindOfClass:[UINavigationController class]] ) {
      [engine addObserver:[vc.viewControllers firstObject]];
    }
  }
  
  [engine prepare];
  [engine connectWithAccount:acnt password:pswd];
  [engine addRosterPushHandler];
  [engine addPresenceHandler];
  [engine addMessageHandler];
}



- (void)engineDidStartConnecting:(ABEngine *)engine
{
  [self HUDStart];
}

- (void)engine:(ABEngine *)engine didReceiveConnectStatus:(BOOL)status
{
  if ( status ) {
    
    [[ABEngine sharedObject] loadContacts];
    
    [[ABEngine sharedObject] requestRosterWithCompletion:^(id result, NSError *error) {
      
      if ( error ) {
        [self HUDConnectNo];
        
        [engine disconnect];
      } else {
        [[ABEngine sharedObject] removeObserver:self];
        [[ABEngine sharedObject] updatePresence:ABPresenceTypeAvailable];
        
        [self HUDConnectYes];
      }
    
    }];
    
  } else {
    [self HUDConnectNo];
  }
}

- (void)engineDidDisconnected:(ABEngine *)engine
{
  [self HUDConnectNo];
}


- (void)HUDStart
{
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
}

- (void)HUDConnectYes
{
  [MBProgressHUD dismissHUD:self.view
                immediately:NO
            completionBlock:^{
              [self.parentViewController dismissChildViewController:self];
            }];
}

- (void)HUDConnectNo
{
  [MBProgressHUD presentTextHUD:self.view
                           info:NSLocalizedString(@"Sign in failed", @"")
                        offsetY:0.0
                completionBlock:NULL];
}

@end
