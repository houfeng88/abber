//
//  ABAddContactViewController.h
//  AbberDemo
//
//  Created by Kevin on 8/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <abber/abber.h>

@interface ABAddContactViewController : TKViewController<
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate
> {
  UITableView *_tableView;
  
  UITextField *_accountField;
  UITextField *_memonameField;
}

@end
