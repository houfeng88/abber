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
  
  _navigationView.titleLabel.text = @"Sign in";
  
  
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
  } else if ( indexPath.row==1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Password:", @"");
    cell.valueField.text = [[TKSettings sharedObject] objectForKey:@"ABSavedPasswordKey"];
    cell.valueField.secureTextEntry = YES;
  }
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 60.0;
  }
  return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *header = [[UIView alloc] init];
  
  UILabel *titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:32.0]
                                     textColor:[UIColor blackColor]
                                 textAlignment:NSTextAlignmentCenter
                                 lineBreakMode:NSLineBreakByTruncatingMiddle
                                 numberOfLines:1
                               backgroundColor:[UIColor clearColor]];
  titleLabel.text = NSLocalizedString(@"Abber", @"");
  [header addSubview:titleLabel];
  titleLabel.frame = CGRectMake(10.0, 5.0, 300.0, 50.0);
  
  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  if ( section==0 ) {
    return 50.0;
  }
  return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  UIView *footer = [[UIView alloc] init];
  footer.frame = CGRectMake(0.0, 0.0, _tableView.width, 49.0);
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = NSLocalizedString(@"Sign In", @"");
  button.normalBackgroundImage = TKCreateResizableImage(@"btn_brown.png", UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0));
  [button addTarget:self action:@selector(signinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = CGRectMake(10.0, 2.0, 300.0, 45.0);
  [footer addSubview:button];
  
  return footer;
}


- (void)signinButtonClicked:(id)sender
{
//  ABRootViewController *root = (ABRootViewController *)(self.parentViewController);
//  ABMainViewController *vc = [[ABMainViewController alloc] init];
//  [root presentWithViewController:vc];
}

@end
