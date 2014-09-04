//
//  ABInfoInputCell.m
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABInfoInputCell.h"

@implementation ABInfoInputCell

- (id)init
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14.0]
                               textColor:[UIColor darkGrayColor]
                           textAlignment:NSTextAlignmentLeft
                           lineBreakMode:NSLineBreakByTruncatingTail
                           numberOfLines:1
                         backgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_titleLabel];
    
    _bodyField = [[UITextField alloc] init];
    _bodyField.font = [UIFont systemFontOfSize:10.0];
    _bodyField.textColor = [UIColor blackColor];
    _bodyField.textAlignment = NSTextAlignmentRight;
    _bodyField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _bodyField.returnKeyType = UIReturnKeyDone;
    _bodyField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _bodyField.adjustsFontSizeToFitWidth = NO;
    _bodyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:_bodyField];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _titleLabel.frame = CGRectMake(10.0, 2.0, 80.0, 40.0);
  _bodyField.frame = CGRectMake(10.0+80.0+5.0, 2.0, self.contentView.width-(10.0+80.0+5.0)-10.0, 40.0);
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 44.0;
}

@end
