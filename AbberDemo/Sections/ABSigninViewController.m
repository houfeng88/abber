//
//  ABSigninViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSigninViewController.h"
#import "ABRootViewController.h"
#import "ABMainViewController.h"
#import "ABSigninCell.h"

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

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
}


- (void)gestureTap:(UIGestureRecognizer *)recognizer
{
  [TKFindFirstResponderInView(_tableView) resignFirstResponder];
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
  ABSigninCell *cell = (ABSigninCell *)[tableView dequeueReusableCellWithClass:[ABSigninCell class]];
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
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(signinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
  [footer addSubview:button];
  
  return footer;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ( textField==_accountField ) {
    [_passwordField becomeFirstResponder];
  } else if ( textField==_passwordField ) {
    [textField resignFirstResponder];
    if ( [self checkValidity] ) {
      [self signin];
    }
  }
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return (([textField.text length] + [string length] - range.length)<=40);
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
  
  if ( !ABOSNonempty(acnt) ) {
    TKPresentSystemMessage(NSLocalizedString(@"Invalid account", @""));
    return NO;
  }
  
  if ( !ABOSNonempty(pswd) ) {
    TKPresentSystemMessage(NSLocalizedString(@"Invalid password", @""));
    return NO;
  }
  
  return YES;
}

- (void)signin
{
  [[TKSettings sharedObject] setObject:_accountField.text forKey:@"ABSavedAccountKey"];
  [[TKSettings sharedObject] setObject:_passwordField.text forKey:@"ABSavedPasswordKey"];
  [[TKSettings sharedObject] synchronize];
  
  [[ABEngine sharedObject] addObserver:self];
  [[ABEngine sharedObject] prepare];
  [[ABEngine sharedObject] connectWithAccount:_accountField.text password:_passwordField.text];
  [[ABEngine sharedObject] addRosterPushHandler];
  [[ABEngine sharedObject] prepareForPresenceUpdate];
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
    
    [self configDatabase:[engine account]];
    
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

- (void)configDatabase:(NSString *)jid
{
  if ( [jid length]>0 ) {
    
    NSString *path = TKPathForDocumentResource(jid);
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL] ) {
      [[NSFileManager defaultManager] createDirectoryAtPath:path
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:NULL];
    }
    
    NSString *dbpath = [path stringByAppendingPathComponent:@"im.db"];
    TKDatabase *db = [[TKDatabase alloc] initWithPath:dbpath];
    [TKDatabase saveObject:db];
    
    [db open];
    
    if ( ![db hasTableNamed:@"contact"] ) {
      NSString *contactSQL = @"CREATE TABLE contact(pk INTEGER PRIMARY KEY, "
                                                  @"jid TEXT, "
                                                  @"nickname TEXT, "
                                                  @"relation INTEGER);";
      [db executeUpdate:contactSQL];
    }
    
  }
}

@end
