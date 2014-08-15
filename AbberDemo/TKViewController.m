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
  
  
//  _navigationView = [[TKNavigationView alloc] init];
//  [_navigationView.backButton addTarget:self
//                                 action:@selector(backButtonClicked:)
//                       forControlEvents:UIControlEventTouchUpInside];
//  [_navigationView.leftButton addTarget:self
//                                 action:@selector(leftButtonClicked:)
//                       forControlEvents:UIControlEventTouchUpInside];
//  [_navigationView.rightButton addTarget:self
//                                  action:@selector(rightButtonClicked:)
//                        forControlEvents:UIControlEventTouchUpInside];
//  [self.view addSubview:_navigationView];
  
  
  _contentView = [[UIView alloc] init];
  _contentView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_contentView];
  
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
  
  _contentView.frame = self.view.bounds;
  
//  [_navigationView sizeToFit];
//  _navigationView.frame = CGRectMake(0.0, 0.0, _navigationView.width, _navigationView.height);
//  
//  if ( TKSystemVersion()<7.0 ) {
//    if ( _navigationView.hidden ) {
//      _contentView.frame = self.view.bounds;
//    } else {
//      _contentView.frame = CGRectMake(0.0, _navigationView.bottomY, self.view.width, self.view.height - _navigationView.bottomY);
//    }
//  } else {
//    if ( _navigationView.hidden ) {
//      _contentView.frame = CGRectMake(0.0, 20.0, self.view.width, self.view.height - 20.0);
//    } else {
//      _contentView.frame = CGRectMake(0.0, _navigationView.bottomY, self.view.width, self.view.height - _navigationView.bottomY);
//    }
//  }
  
}


- (void)backButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClicked:(id)sender
{
  TKPRINTMETHOD();
}

- (void)rightButtonClicked:(id)sender
{
  TKPRINTMETHOD();
}

@end


//@implementation TKNavigationView
//
//- (id)init
//{
//  self = [super init];
//  if (self) {
//    
//    _backgroundImageView = [[UIImageView alloc] init];
//    _backgroundImageView.backgroundColor = [UIColor clearColor];
//    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//    [self addSubview:_backgroundImageView];
//    
//    NSString *imageName = @"navbar_bg_low.png";
//    if ( TKSystemVersion()>=7.0 ) {
//      imageName = @"navbar_bg_high.png";
//    }
//    [_backgroundImageView loadImageNamed:imageName];
//    
//    
//    TBButton *button = [[TBButton alloc] init];
//    button.normalImage = TBCreateImage(@"btn_back.png");
//    button.exclusiveTouch = YES;
//    button.hidden = YES;
//    [self addSubview:button];
//    _backButton = button;
//    
//    
//    button = [[TBButton alloc] init];
//    button.normalBackgroundImage = [TBCreateImage(@"btn_orange.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
//    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    button.exclusiveTouch = YES;
//    button.hidden = YES;
//    [self addSubview:button];
//    _leftButton = button;
//    
//    
//    _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:20.0]
//                               textColor:[UIColor blackColor]
//                           textAlignment:NSTextAlignmentCenter
//                           lineBreakMode:NSLineBreakByTruncatingMiddle
//                           numberOfLines:1
//                         backgroundColor:[UIColor clearColor]];
//    [self addSubview:_titleLabel];
//    
//    
//    button = [[TBButton alloc] init];
//    button.normalBackgroundImage = [TBCreateImage(@"btn_orange.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
//    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    button.exclusiveTouch = YES;
//    button.hidden = YES;
//    [self addSubview:button];
//    _rightButton = button;
//    
//  }
//  return self;
//}
//
//- (void)layoutSubviews
//{
//  [super layoutSubviews];
//  
//  _backgroundImageView.frame = CGRectMake(0.0, 0.0, self.width, self.height+NAV_SHADOW);
//  
//  
//  CGFloat leftWidth = 0.0;
//  if ( !(_backButton.hidden) ) {
//    leftWidth = 44.0;
//  } else {
//    if ( !(_leftButton.hidden) ) {
//      if ( [_leftButton.normalTitle length]>0 ) {
//        CGSize leftSize = [_leftButton sizeThatFits:CGSizeZero];
//        leftWidth = leftSize.width;
//        leftWidth += 10.0;
//        leftWidth = MAX(62.0, leftWidth);
//      } else {
//        leftWidth = _leftButton.normalImage.size.width;
//        leftWidth = MAX(44.0, leftWidth);
//      }
//    }
//  }
//  
//  CGFloat rightWidth = 0.0;
//  if ( !(_rightButton.hidden) ) {
//    if ( [_rightButton.normalTitle length]>0 ) {
//      CGSize rightSize = [_rightButton sizeThatFits:CGSizeZero];
//      rightWidth = rightSize.width;
//      rightWidth += 10.0;
//      rightWidth = MAX(62.0, rightWidth);
//    } else {
//      rightWidth = _rightButton.normalImage.size.width;
//      rightWidth = MAX(44.0, rightWidth);
//    }
//  }
//  
//  CGFloat maxWidth = MAX(leftWidth, rightWidth);
//  
//  CGFloat titleWidth = self.width - (5.0+maxWidth+5.0) * 2.0;
//  
//  
//  CGFloat base = 0.0;
//  if ( TKSystemVersion()>=7.0 ) {
//    base = 20.0;
//  }
//  
//  _backButton.frame = CGRectMake(5.0, base+8.0, leftWidth, 44.0);
//  _leftButton.frame = CGRectMake(5.0, base+8.0, leftWidth, 44.0);
//  _titleLabel.frame = CGRectMake(5.0+maxWidth+5.0, base+8.0, titleWidth, 44.0);
//  _rightButton.frame = CGRectMake(self.width-5.0-rightWidth, base+8.0, rightWidth, 44.0);
//  
//}
//
//- (CGSize)sizeThatFits:(CGSize)size
//{
//  CGFloat height = NAV_HEIGHT;
//  if ( [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ) {
//    height += 20.0;
//  }
//  return CGSizeMake([[UIScreen mainScreen] bounds].size.width, height);
//}
//
//
//
//- (void)showBackButton
//{
//  _backButton.hidden = NO;
//  _leftButton.hidden = YES;
//}
//
//- (void)showLeftButton
//{
//  _backButton.hidden = YES;
//  _leftButton.hidden = NO;
//}
//
//- (void)showRightButton
//{
//  _rightButton.hidden = NO;
//}
//
//@end
