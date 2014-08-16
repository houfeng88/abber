//
//  ABSigninCell.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSigninCell.h"

@implementation ABSigninCell

- (id)init
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _titleLabel = [UILabel singleLineLabelWithFont:[UIFont systemFontOfSize:14.0]
                                         textColor:[UIColor blackColor]];
    [self.contentView addSubview:_titleLabel];
    
    _valueField = [[UITextField alloc] init];
    _valueField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _valueField.font = [UIFont systemFontOfSize:14.0];
    _valueField.textColor = [UIColor blackColor];
    _valueField.textAlignment = NSTextAlignmentLeft;
    _valueField.adjustsFontSizeToFitWidth = NO;
    _valueField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:_valueField];
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _titleLabel.frame = CGRectMake(10.0, 2.0, 100.0, self.contentView.height-2*2.0);
  
  _valueField.frame = CGRectMake(_titleLabel.rightX+5.0, 2.0, self.contentView.width-10.0-(_titleLabel.rightX+5.0), self.contentView.height-2*2.0);
  
}

@end
