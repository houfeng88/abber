//
//  TKNavigationView.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKNavigationView.h"

@implementation TKNavigationView

- (id)init
{
  self = [super init];
  if (self) {
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_backgroundImageView];
    
    TKButton *button = [[TKButton alloc] init];
    button.exclusiveTouch = YES;
    button.hidden = YES;
    [self addSubview:button];
    _backButton = button;
    
    
    button = [[TKButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.exclusiveTouch = YES;
    button.hidden = YES;
    [self addSubview:button];
    _leftButton = button;
    
    
    _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:20.0]
                               textColor:[UIColor blackColor]
                           textAlignment:NSTextAlignmentCenter
                           lineBreakMode:NSLineBreakByTruncatingMiddle
                           numberOfLines:1
                         backgroundColor:[UIColor clearColor]];
    [self addSubview:_titleLabel];
    
    
    button = [[TKButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.exclusiveTouch = YES;
    button.hidden = YES;
    [self addSubview:button];
    _rightButton = button;
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _backgroundImageView.frame = CGRectMake(0.0, 0.0, self.width, self.height+NAVIGATION_SHADOW);
  
  
  CGFloat leftWidth = 0.0;
  if ( !(_backButton.hidden) ) {
    CGSize size = [_backButton mostFitSize];
    leftWidth = size.width;
  } else {
    if ( !(_leftButton.hidden) ) {
      CGSize size = [_leftButton mostFitSize];
      leftWidth = size.width;
    }
  }
  
  CGFloat rightWidth = 0.0;
  if ( !(_rightButton.hidden) ) {
    CGSize size = [_rightButton mostFitSize];
    rightWidth = size.width;
  }
  
  CGFloat sideWidth = MAX(leftWidth, rightWidth);
  
  
  CGFloat y = (self.height - 44.0) / 2.0;
  
  if ( [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ) {
    y = 20.0 + ((self.height - 20.0) - 44.0) / 2.0;
  }
  
  _backButton.frame = CGRectMake(5.0, y, leftWidth, 44.0);
  _leftButton.frame = CGRectMake(5.0, y, leftWidth, 44.0);
  _titleLabel.frame = CGRectMake(5.0+sideWidth+5.0, y, self.width-(5.0+sideWidth+5.0)*2.0, 44.0);
  _rightButton.frame = CGRectMake(self.width-5.0-rightWidth, y, rightWidth, 44.0);
  
}

- (CGSize)sizeThatFits:(CGSize)size
{
  CGFloat height = NAVIGATION_HEIGHT;
  if ( [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ) {
    height += 20.0;
  }
  return CGSizeMake([[UIScreen mainScreen] bounds].size.width, height);
}



- (void)showBackButton
{
  _backButton.hidden = NO;
  _leftButton.hidden = YES;
}

- (void)showLeftButton
{
  _backButton.hidden = YES;
  _leftButton.hidden = NO;
}

- (void)showRightButton
{
  _rightButton.hidden = NO;
}

@end


@implementation TKButton

- (instancetype)init
{
  self = [super init];
  if (self) {
    _fraction = 2.0;
    _side = 10.0;
  }
  return self;
}

- (CGSize)mostFitSize
{
  CGSize size = CGSizeZero;
  
  UIImage *image = self.normalImage;
  if ( image ) {
    size = image.size;
  } else {
    NSString *title = self.normalTitle;
    if ( [title length]>0 ) {
      size = [title sizeWithFont:self.titleLabel.font];
    }
  }
  
  image = self.normalBackgroundImage;
  if ( image ) {
    return CGSizeMake(image.size.width-_fraction+size.width, image.size.height);
  } else {
    return CGSizeMake(size.width+2*_side, size.height);
  }
  
  return [super sizeThatFits:CGSizeZero];
}

@end
