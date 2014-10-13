//
//  ABUserInfoViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABUserInfoViewController.h"

#import "ABInfoInputCell.h"
#import "ABInfoStaticCell.h"

@implementation ABUserInfoViewController

- (id)init
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
    
    _user = [[ABEngine sharedObject] user];
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

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [[ABEngine sharedObject] requestVcard:nil
                             completion:^(id result, NSError *error) {
                               if ( result ) {
                                 _user = result;
                                 [_tableView reloadData];
                               }
                             }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row==0 ) {
    ABInfoStaticCell *cell = (ABInfoStaticCell *)[tableView dequeueReusableCellWithClass:[ABInfoStaticCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Jid", @"");
    cell.bodyLabel.text = _user.jid;
    return cell;
  } else if ( indexPath.row==1 ) {
    ABInfoInputCell *cell = (ABInfoInputCell *)[tableView dequeueReusableCellWithClass:[ABInfoInputCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Nickname", @"");
    cell.bodyField.text = _user.nickname;
    cell.bodyField.returnKeyType = UIReturnKeyNext;
    cell.bodyField.maxLength = 20;
    _nicknameField = cell.bodyField;
    [(TKTextField *)_nicknameField setNextField:_descField];
    [(TKTextField *)_descField setNextField:nil];
    return cell;
  } else if ( indexPath.row==2 ) {
    ABInfoInputCell *cell = (ABInfoInputCell *)[tableView dequeueReusableCellWithClass:[ABInfoInputCell class]];
    cell.titleLabel.text = NSLocalizedString(@"Desc", @"");
    cell.bodyField.text = _user.desc;
    cell.bodyField.returnKeyType = UIReturnKeyDone;
    cell.bodyField.maxLength = 20;
    _descField = cell.bodyField;
    [(TKTextField *)_nicknameField setNextField:_descField];
    [(TKTextField *)_descField setNextField:nil];
    return cell;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row==0 ) {
    return [ABInfoStaticCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==1 ) {
    return [ABInfoInputCell heightForTableView:tableView object:nil];
  } else if ( indexPath.row==2 ) {
    return [ABInfoInputCell heightForTableView:tableView object:nil];
  }
  return 0.0;
}


- (void)rightButtonClicked:(id)sender
{
  [TKFindFirstResponderInView(self.view) resignFirstResponder];
  
  [self HUDStart];
  
  NSMutableDictionary *vcard = [[NSMutableDictionary alloc] init];
  
  if ( TKSNonempty(_nicknameField.text) ) {
    [vcard setObject:_nicknameField.text forKey:@"nickname"];
  }
  
  if ( TKSNonempty(_descField.text) ) {
    [vcard setObject:_descField.text forKey:@"desc"];
  }
  
  [[ABEngine sharedObject] updateVcard:TKMapOrLater(vcard, nil) completion:^(id result, NSError *error) {
    if ( error ) {
      [self HUDUpdateNo];
    } else {
      _user = [[ABEngine sharedObject] user];
      _user.nickname = _nicknameField.text;
      _user.desc = _descField.text;
      [[ABEngine sharedObject] syncUser];
      [self HUDUpdateYes];
    }
  }];
}


- (void)HUDStart
{
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
}

- (void)HUDUpdateYes
{
  [MBProgressHUD dismissHUD:self.view
                immediately:NO
            completionBlock:NULL];
}

- (void)HUDUpdateNo
{
  [MBProgressHUD presentTextHUD:self.view
                           info:NSLocalizedString(@"Change failed", @"")
                        offsetY:0.0
                completionBlock:NULL];
}

@end
