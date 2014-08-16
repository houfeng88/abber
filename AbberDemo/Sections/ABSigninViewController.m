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

- (void)signin:(id)sender
{
  ABRootViewController *root = (ABRootViewController *)(self.parentViewController);
  ABMainViewController *vc = [[ABMainViewController alloc] init];
  [root presentWithViewController:vc];
}

@end
