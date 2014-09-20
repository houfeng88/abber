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

@class TKButton;

@interface TKNavigationView : UIView {
  UIImageView *_backgroundImageView;
  TKButton *_backButton;
  TKButton *_leftButton;
  UILabel *_titleLabel;
  TKButton *_rightButton;
}

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong, readonly) TKButton *backButton;
@property (nonatomic, strong, readonly) TKButton *leftButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) TKButton *rightButton;

- (void)showBackButton;
- (void)showLeftButton;
- (void)showRightButton;

@end


@interface TKButton : UIButton {
  id _info;
  
  CGFloat _fraction;
  CGFloat _side;
}

@property (nonatomic, strong) id info;

@property (nonatomic, assign) CGFloat fraction;
@property (nonatomic, assign) CGFloat side;

- (CGSize)mostFitSize;

@end
