//
//  ABSigninViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "General/TKViewController.h"
#import <abber/abber.h>

@interface ABSigninViewController : TKViewController<
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate
> {
  UITableView *_tableView;
  UITextField *_accountField;
  UITextField *_passwordField;
}

@end
