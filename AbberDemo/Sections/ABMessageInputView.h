//
//  ABMessageInputView.h
//  AbberDemo
//
//  Created by Kevin on 10/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABMessageInputView : UIImageView<
  UITextFieldDelegate
> {
  UIImageView *_backgroundView;
  UITextField *_textField;
  UIButton *_button;
}

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;

@end
