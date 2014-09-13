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
    button.normalTitleColor = [UIColor whiteColor];
    button.highlightedTitleColor = [UIColor lightGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
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
    button.normalTitleColor = [UIColor whiteColor];
    button.highlightedTitleColor = [UIColor lightGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
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
  
  CGSize leftSize = CGSizeZero;
  if ( !(_backButton.hidden) ) {
    leftSize = [_backButton mostFitSize];
  } else {
    if ( !(_leftButton.hidden) ) {
      leftSize = [_leftButton mostFitSize];
    }
  }
  
  CGSize rightSize = CGSizeZero;
  if ( !(_rightButton.hidden) ) {
    rightSize = [_rightButton mostFitSize];
  }
  
  CGFloat sideWidth = MAX(leftSize.width, rightSize.width);
  
  
  CGFloat baseline = 20.0;
  
  _backButton.frame = CGRectMake(5.0, baseline+((self.height-baseline)-leftSize.height)/2.0, leftSize.width, leftSize.height);
  _leftButton.frame = CGRectMake(5.0, baseline+((self.height-baseline)-leftSize.height)/2.0, leftSize.width, leftSize.height);
  _titleLabel.frame = CGRectMake(5.0+sideWidth+5.0, baseline, self.width-(5.0+sideWidth+5.0)*2.0, self.height-baseline);
  _rightButton.frame = CGRectMake(self.width-5.0-rightSize.width, baseline+((self.height-baseline)-rightSize.height)/2.0, rightSize.width, rightSize.height);
  
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake([[UIScreen mainScreen] bounds].size.width, NAVIGATION_HEIGHT+20.0);
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
    if ( TKSNonempty(title) ) {
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
