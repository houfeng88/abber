//
//  ABMessageInputView.m
//  AbberDemo
//
//  Created by Kevin on 10/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMessageInputView.h"

@implementation ABMessageInputView

- (id)init
{
  self = [super init];
  if (self) {
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.image = TKCreateImage(@"inputbar_bg.png");
    self.contentMode = UIViewContentModeScaleToFill;
    
    
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.image = TKCreateResizableImage(@"inputbar_field.png", TKInsets(5, 5, 5, 5));
    _backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_backgroundView];
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:14.0];
    _textField.textColor = [UIColor blackColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.adjustsFontSizeToFitWidth = NO;
    _textField.clearButtonMode = UITextFieldViewModeNever;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_textField];
    
    _button = [[UIButton alloc] init];
    _button.normalTitle = NSLocalizedString(@"Send", @"");
    _button.normalTitleColor = [UIColor darkGrayColor];
    _button.highlightedTitleColor = [UIColor lightGrayColor];
    _button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_button];
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 49.0);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _backgroundView.frame = CGRectMake(10.0, 7.0, self.width-10.0-5.0-50.0-10.0, 35.0);
  
  _textField.frame = CGRectInset(_backgroundView.frame, 5.0, 0.0);
  
  _button.frame = CGRectMake(self.width-10.0-50.0, 7.0, 50.0, 35.0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [_textField resignFirstResponder];
  return YES;
}

@end
