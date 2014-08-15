//
//  TKViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKViewController.h"

@implementation TKViewController

- (id)init
{
  self = [super init];
  if (self) {
    if ( [[[UIDevice currentDevice] systemVersion] floatValue]<7.0 ) {
      self.wantsFullScreenLayout = YES;
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if ( [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  
  _navigationView = [[TKNavigationView alloc] init];
  [_navigationView.backButton addTarget:self
                                 action:@selector(backButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
  [_navigationView.leftButton addTarget:self
                                 action:@selector(leftButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
  [_navigationView.rightButton addTarget:self
                                  action:@selector(rightButtonClicked:)
                        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_navigationView];
  
  
  _contentView = [[UIView alloc] init];
  _contentView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_contentView];
  
  // TODO: ...
  _navigationView.backgroundImageView.image = TKCreateImage(@"navbar_bg.png");
  _navigationView.titleLabel.textColor = [UIColor whiteColor];
  _navigationView.backButton.normalBackgroundImage = TKCreateImage(@"btn_back_1.png");
  _navigationView.backButton.highlightedBackgroundImage = TKCreateImage(@"btn_back_2.png");
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  _viewAppeared = YES;
  _appearedTimes++;
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  _viewAppeared = NO;
}


- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  [self layoutViews];
}

- (void)layoutViews
{
  [_navigationView sizeToFit];
  _navigationView.frame = CGRectMake(0.0, 0.0, _navigationView.width, _navigationView.height);
  
  if ( _navigationView.hidden ) {
    _contentView.frame = CGRectMake(0.0, 20.0, self.view.width, self.view.height - 20.0);
  } else {
    _contentView.frame = CGRectMake(0.0, _navigationView.bottomY, self.view.width, self.view.height - _navigationView.bottomY);
  }
}


- (void)backButtonClicked:(id)sender
{
  DDLogDebug(@"[client Back button clicked]");
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClicked:(id)sender
{
  DDLogDebug(@"[client Left button clicked]");
}

- (void)rightButtonClicked:(id)sender
{
  DDLogDebug(@"[client Right button clicked]");
}

@end
