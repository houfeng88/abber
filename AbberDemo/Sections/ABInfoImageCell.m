//
//  ABInfoImageCell.m
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABInfoImageCell.h"

@implementation ABInfoImageCell

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
    
    _bodyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:10.0]
                              textColor:[UIColor blackColor]
                          textAlignment:NSTextAlignmentRight
                          lineBreakMode:NSLineBreakByTruncatingHead
                          numberOfLines:1
                        backgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_bodyLabel];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _titleLabel.frame = CGRectMake(10.0, 2.0, 80.0, 40.0);
  _bodyLabel.frame = CGRectMake(10.0+80.0+5.0, 2.0, self.contentView.width-(10.0+80.0+5.0)-10.0, 40.0);
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 44.0;
}

@end
