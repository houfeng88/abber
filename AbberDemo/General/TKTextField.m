//
//  TKTextField.m
//  AbberDemo
//
//  Created by Kevin Wu on 9/19/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKTextField.h"

@implementation TKTextField

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( _nextField ) {
        [_nextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( _maxLength>0 ) {
        return (([textField.text length] + [string length] - range.length)<=_maxLength);
    }
    return YES;
}

@end
