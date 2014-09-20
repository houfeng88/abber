//
//  ABContactCell.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/18/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABContactCell.h"

@implementation ABContactCell

- (id)init
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self className]];
  if (self) {
    
    _avatarView = [[UIImageView alloc] init];
    _avatarView.contentMode = UIViewContentModeScaleToFill;
    _avatarView.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = 3.0;
    _avatarView.image = TKCreateImage(@"default_avatar.png");
    [self.contentView addSubview:_avatarView];
    
    _nicknameLabel = [UILabel singleLineLabelWithFont:[UIFont systemFontOfSize:14.0]
                                            textColor:[UIColor blackColor]];
    [self.contentView addSubview:_nicknameLabel];
    
    _statusLabel = [UILabel singleLineLabelWithFont:[UIFont systemFontOfSize:10.0]
                                          textColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:_statusLabel];
    
    _descLabel = [UILabel singleLineLabelWithFont:[UIFont systemFontOfSize:10.0]
                                        textColor:[UIColor darkGrayColor]];
    [self.contentView addSubview:_descLabel];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _avatarView.frame = CGRectMake(10.0, 5.0, 40.0, 40.0);
  
  _nicknameLabel.frame = CGRectMake(_avatarView.rightX+5.0, 2.0,
                                    self.contentView.width-(_avatarView.rightX+5.0)-10.0, 25.0);
  
  [_statusLabel sizeToFit];
  _statusLabel.frame = CGRectMake(_nicknameLabel.leftX, _nicknameLabel.bottomY,
                                  _statusLabel.width, 15.0);
  _descLabel.frame = CGRectMake(_statusLabel.rightX+5.0, _nicknameLabel.bottomY,
                                _nicknameLabel.width-(_statusLabel.width+5.0), 15.0);
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 50.0;
}

@end
