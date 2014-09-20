//
//  ABInfoInputCell.h
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common/TKTextField.h"

@interface ABInfoInputCell : UITableViewCell {
  UILabel *_titleLabel;
  TKTextField *_bodyField;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) TKTextField *bodyField;

@end
