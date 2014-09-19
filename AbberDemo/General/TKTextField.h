//
//  TKTextField.h
//  AbberDemo
//
//  Created by Kevin Wu on 9/19/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKTextField : UITextField<
    UITextFieldDelegate
> {
    NSUInteger _maxLength;
    __weak UITextField *_nextField;
}

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, weak) UITextField *nextField;

@end
