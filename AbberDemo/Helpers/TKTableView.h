//
//  TKTableView.h
//  RefreshDemo
//
//  Created by Kevin Wu on 7/17/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKRefreshControl.h"
#import "UITableViewExtentions.h"

typedef void(^TKRefreshBlock)(void);

@interface TKTableView : UITableView {
  UIRefreshControl *_initialRefreshControl;
  TKRefreshBlock _initialRefreshBlock;
  
  TKRefreshControl *_infiniteRefreshControl;
  TKRefreshBlock _infiniteRefreshBlock;
}

@property (nonatomic, strong, readonly) UIRefreshControl *initialRefreshControl;

@property (nonatomic, strong, readonly) TKRefreshControl *infiniteRefreshControl;


- (void)startInitialRefreshing:(BOOL)animated;
- (void)stopInitialRefreshing:(BOOL)animated;
- (void)addInitialRefreshControlWithRefreshBlock:(TKRefreshBlock)block;
- (void)removeInitialRefreshControl;
- (void)updateInitialRefreshControlTitle:(NSString *)title;

- (void)startInfiniteRefreshing:(BOOL)animated;
- (void)stopInfiniteRefreshing:(BOOL)animated;
- (void)addInfiniteRefreshControlWithRefreshBlock:(TKRefreshBlock)block;
- (void)removeInfiniteRefreshControl;

@end
