//
//  ABFriendsViewController.h
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <abber/abber.h>

@interface ABFriendsViewController : TKViewController<
    UITableViewDataSource,
    UITableViewDelegate
> {
  TKTableView *_tableView;
  
  NSArray *_contactAry;
}

@end
