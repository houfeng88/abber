//
//  TKNavigationView.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAVIGATION_HEIGHT (44.0)
#define NAVIGATION_SHADOW (0.0)

@interface TKNavigationView : UIView {
  UIImageView *_backgroundImageView;
  UIButton *_backButton;
  UIButton *_leftButton;
  UILabel *_titleLabel;
  UIButton *_rightButton;
}

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *rightButton;

- (void)showBackButton;
- (void)showLeftButton;
- (void)showRightButton;

@end
