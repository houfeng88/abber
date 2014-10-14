//
//  ABMessageCell.h
//  AbberDemo
//
//  Created by Kevin on 10/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABMessageCell : UITableViewCell {
  UILabel *_titleLabel;
  UILabel *_bodyLabel;
  
  BOOL _received;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *bodyLabel;

- (void)updateReceived:(BOOL)received;

@end
