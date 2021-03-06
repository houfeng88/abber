//
//  ABInputCell.h
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common/TKTextField.h"

@interface ABInputCell : UITableViewCell {
  UILabel *_titleLabel;
  TKTextField *_valueField;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) TKTextField *valueField;

@end
