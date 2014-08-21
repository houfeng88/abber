//
//  ABProfileViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/18/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <abber/abber.h>

@interface ABProfileViewController : TKViewController<
    UITableViewDataSource,
    UITableViewDelegate
> {
  UITableView *_tableView;
  
  UIView *_headerView;
  UIView *_footerView;
  
  TKDatabaseRow *_row;
}

- (id)initWithContact:(TKDatabaseRow *)contact;

@end
