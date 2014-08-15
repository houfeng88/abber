//
//  TKViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKButton.h"

#define NAV_HEIGHT (45.0)
#define NAV_SHADOW (0.0)

@class TKNavigationView;

@interface TKViewController : UIViewController {
  TKNavigationView *_navigationView;
  UIView *_contentView;
  
  BOOL _viewAppeared;
  NSUInteger _appearedTimes;
}

@property (nonatomic, readonly) BOOL viewAppeared;
@property (nonatomic, readonly) NSUInteger appearedTimes;

- (void)layoutViews;

- (void)backButtonClicked:(id)sender;
- (void)leftButtonClicked:(id)sender;
- (void)rightButtonClicked:(id)sender;

@end


//@interface TKNavigationView : UIView {
//  UIImageView *_backgroundImageView;
//  TKButton *_backButton;
//  TKButton *_leftButton;
//  UILabel *_titleLabel;
//  TKButton *_rightButton;
//}
//
//@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
//@property (nonatomic, strong, readonly) TKButton *backButton;
//@property (nonatomic, strong, readonly) TKButton *leftButton;
//@property (nonatomic, strong, readonly) UILabel *titleLabel;
//@property (nonatomic, strong, readonly) TKButton *rightButton;
//
//- (void)showBackButton;
//- (void)showLeftButton;
//- (void)showRightButton;
//
//@end
