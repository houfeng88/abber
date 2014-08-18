//
//  TKRefreshControl.h
//  RefreshDemo
//
//  Created by Kevin Wu on 7/17/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKRefreshControl : UIControl {
  UIActivityIndicatorView *_activityIndicatorView;
  BOOL _triggered;
  
  BOOL _refreshing;
}

@property (nonatomic, readonly) BOOL refreshing;


- (void)beginRefreshing;

- (void)endRefreshing;

@end
