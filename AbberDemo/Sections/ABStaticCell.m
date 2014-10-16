//
//  ABStaticCell.m
//  AbberDemo
//
//  Created by Kevin on 10/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABStaticCell.h"

@implementation ABStaticCell

- (id)init
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
  if (self) {
    
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
  
  _titleLabel.frame = CGRectMake(10.0,
                                 2.0,
                                 200.0,
                                 self.contentView.height-2*2.0);
  
  _bodyLabel.frame = CGRectMake(_titleLabel.rightX+5.0,
                                2.0,
                                self.contentView.width-10.0-(_titleLabel.rightX+5.0),
                                self.contentView.height-2*2.0);
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 44.0;
}

@end
