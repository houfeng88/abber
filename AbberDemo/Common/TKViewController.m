//
//  TKViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKViewController.h"

@implementation TKViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  
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
  _navigationView.backgroundImageView.image = TKCreateResizableImage(@"navbar_bg.png", TKInsets(2.0, 2.0, 2.0, 2.0));
  _navigationView.titleLabel.textColor = [UIColor whiteColor];
  _navigationView.backButton.normalImage = TKCreateImage(@"btn_back.png");
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
  DDLogDebug(@"[client] Back button clicked");
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClicked:(id)sender
{
  DDLogDebug(@"[client] Left button clicked");
}

- (void)rightButtonClicked:(id)sender
{
  DDLogDebug(@"[client] Right button clicked");
}


- (void)HUDStart
{
  [MBProgressHUD presentProgressHUD:self.view
                               info:nil
                            offsetY:0.0];
}

- (void)HUDYes:(BOOL)dismiss
{
  [MBProgressHUD dismissHUD:self.view
                immediately:NO
            completionBlock:^{
              if ( dismiss ) {
                [self.navigationController popViewControllerAnimated:YES];
              }
            }];
}

- (void)HUDNo:(NSString *)info
{
  [MBProgressHUD presentTextHUD:self.view
                           info:info
                        offsetY:0.0
                completionBlock:NULL];
}



- (void)addResignGestureInView:(UIView *)view
{
  if ( !_resignRecognizer ) {
    _resignRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(resignGesture:)];
    _resignRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:_resignRecognizer];
  }
}

- (void)removeResignGestureInView:(UIView *)view
{
  [view removeGestureRecognizer:_resignRecognizer];
  _resignRecognizer = nil;
}

- (void)resignGesture:(UIGestureRecognizer *)recognizer
{
  [TKFindFirstResponderInView(self.view) resignFirstResponder];
}

@end
