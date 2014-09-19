//
//  ABInputCell.m
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABInputCell.h"

@implementation ABInputCell

- (id)init
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14.0]
                               textColor:[UIColor blackColor]
                           textAlignment:NSTextAlignmentRight
                           lineBreakMode:NSLineBreakByTruncatingHead
                           numberOfLines:1
                         backgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_titleLabel];
    
    _valueField = [[TKTextField alloc] init];
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
  
  _titleLabel.frame = CGRectMake(10.0, 2.0, 90.0, self.contentView.height-2*2.0);
  
  _valueField.frame = CGRectMake(_titleLabel.rightX+5.0,
                                 2.0,
                                 self.contentView.width-10.0-(_titleLabel.rightX+5.0),
                                 self.contentView.height-2*2.0);
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 44.0;
}

@end
