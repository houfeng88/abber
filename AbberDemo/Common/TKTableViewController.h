//
//  TKTableViewController.h
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKViewController.h"
#import "TKTableView.h"

@interface TKTableViewController : TKViewController<
    UITableViewDataSource,
    UITableViewDelegate
> {
  TKTableView *_tableView;
}

@end
