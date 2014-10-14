//
//  ABMessageCell.m
//  AbberDemo
//
//  Created by Kevin on 10/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMessageCell.h"

#define BoxWidth  (200.0)

@implementation ABMessageCell

- (id)init
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:10.0]
                               textColor:[UIColor darkGrayColor]
                           textAlignment:NSTextAlignmentLeft
                           lineBreakMode:NSLineBreakByTruncatingTail
                           numberOfLines:1
                         backgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_titleLabel];
    
    _bodyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14.0]
                              textColor:[UIColor blackColor]
                          textAlignment:NSTextAlignmentLeft
                          lineBreakMode:NSLineBreakByWordWrapping
                          numberOfLines:0
                        backgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_bodyLabel];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _titleLabel.frame = CGRectMake(10.0, 2.0, 300.0, 15.0);
  
  
  CGRect rect = [_bodyLabel.text boundingRectWithSize:CGSizeMake(BoxWidth, 10000.0)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{ NSFontAttributeName:_bodyLabel.font }
                                              context:nil];
  
  if ( _received ) {
    _bodyLabel.frame = CGRectMake(10.0, _titleLabel.bottomY+2.0, BoxWidth, rect.size.height);
  } else {
    _bodyLabel.frame = CGRectMake(self.contentView.width-10.0-BoxWidth, _titleLabel.bottomY+2.0, BoxWidth, rect.size.height);
  }
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  CGFloat height = 0.0;
  
  height += 2.0;
  height += 15.0;
  
  height += 2.0;
  CGRect rect = [object boundingRectWithSize:CGSizeMake(BoxWidth, 10000.0)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0] }
                                              context:nil];
  height += rect.size.height;
  
  height += 2.0;
  
  return height;
}


- (void)updateReceived:(BOOL)received
{
  _received = received;
  
  if ( _received ) {
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _bodyLabel.textAlignment = NSTextAlignmentLeft;
    _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
  } else {
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    
    _bodyLabel.textAlignment = NSTextAlignmentRight;
    _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
  }
  
  [self setNeedsLayout];
}

@end
