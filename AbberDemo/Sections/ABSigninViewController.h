//
//  ABSigninViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <abber/abber.h>

@interface ABSigninViewController : TKTableViewController<
    UITextFieldDelegate
> {
  UITextField *_accountField;
  UITextField *_passwordField;
}

@end
