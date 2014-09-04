//
//  ABContactCell.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/18/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABContactCell : UITableViewCell {
  UIImageView *_avatarView;
  UILabel *_nicknameLabel;
  UILabel *_statusLabel;
  UILabel *_descLabel;
}

@property (nonatomic, strong, readonly) UIImageView *avatarView;
@property (nonatomic, strong, readonly) UILabel *nicknameLabel;
@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UILabel *descLabel;

@end
