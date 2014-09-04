//
//  ABInfoInputCell.h
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABInfoInputCell : UITableViewCell {
  UILabel *_titleLabel;
  UITextField *_bodyField;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UITextField *bodyField;

@end
