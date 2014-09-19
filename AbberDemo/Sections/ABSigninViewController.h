//
//  ABSigninViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <abber/abber.h>
#import "General/TKTextField.h"

@interface ABSigninViewController : TKTableViewController {
  TKTextField *_accountField;
  TKTextField *_passwordField;
}

@end
