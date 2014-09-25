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
    
    
    
    UIButton *button = [[UIButton alloc] init];
    button.exclusiveTouch = YES;
    button.hidden = YES;
    [self addSubview:button];
    _backButton = button;
    
    
    button = [[UIButton alloc] init];
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
    
    
    button = [[UIButton alloc] init];
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
  
  
  CGFloat baseline = 20.0;
  
  _backButton.frame = CGRectMake(5.0, baseline+((self.height-baseline)-40.0)/2.0, 60.0, 40.0);
  _leftButton.frame = CGRectMake(5.0, baseline+((self.height-baseline)-40.0)/2.0, 60.0, 40.0);
  _titleLabel.frame = CGRectMake(5.0+60.0+5.0, baseline, self.width-(5.0+60.0+5.0)*2.0, self.height-baseline);
  _rightButton.frame = CGRectMake(self.width-5.0-60.0, baseline+((self.height-baseline)-40.0)/2.0, 60.0, 40.0);
  
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
