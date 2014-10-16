//
//  TKTableView.m
//  RefreshDemo
//
//  Created by Kevin Wu on 7/17/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKTableView.h"

@implementation TKTableView

- (void)startInitialRefreshing:(BOOL)animated
{
  if ( _initialRefreshControl ) {
    [_initialRefreshControl beginRefreshing];
    [self setContentOffset:CGPointMake(0.0, 0.0-_initialRefreshControl.height) animated:animated];
  }
}

- (void)stopInitialRefreshing:(BOOL)animated
{
  if ( _initialRefreshControl ) {
    [_initialRefreshControl endRefreshing];
  }
}

- (void)addInitialRefreshControlWithRefreshBlock:(TKRefreshBlock)block
{
  if ( !_initialRefreshControl ) {
    _initialRefreshControl = [[UIRefreshControl alloc] init];
    [self addSubview:_initialRefreshControl];
    [_initialRefreshControl sendToBack];
    
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self;
    tvc.refreshControl = _initialRefreshControl;
    
    [_initialRefreshControl addTarget:self
                               action:@selector(initialValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
  }
  
  _initialRefreshBlock = [block copy];
}

- (void)removeInitialRefreshControl
{
  [_initialRefreshControl removeFromSuperview];
  _initialRefreshControl = nil;
}

- (void)updateInitialRefreshControlTitle:(NSString *)title
{
  NSAttributedString *info = nil;
  if ( [title length]>0 ) {
    info = [[NSAttributedString alloc] initWithString:title];
  }
  _initialRefreshControl.attributedTitle = info;
}



- (void)startInfiniteRefreshing:(BOOL)animated
{
  if ( _infiniteRefreshControl ) {
    [_infiniteRefreshControl beginRefreshing];
    [self setContentOffset:CGPointMake(0.0, _infiniteRefreshControl.bottomY-self.height) animated:animated];
  }
}

- (void)stopInfiniteRefreshing:(BOOL)animated
{
  if ( _infiniteRefreshControl ) {
    [_infiniteRefreshControl endRefreshing];
  }
}

- (void)addInfiniteRefreshControlWithRefreshBlock:(TKRefreshBlock)block
{
  if ( self.contentSize.height>=self.height ) {
    if ( !_infiniteRefreshControl ) {
      _infiniteRefreshControl = [[TKRefreshControl alloc] init];
      [self addSubview:_infiniteRefreshControl];
      [_infiniteRefreshControl sendToBack];
      
      [_infiniteRefreshControl sizeToFit];
      _infiniteRefreshControl.frame = CGRectMake(0.0, MAX(self.contentSize.height, self.height),
                                                 _infiniteRefreshControl.width,
                                                 _infiniteRefreshControl.height);
      
      UIEdgeInsets edgeInsets = self.contentInset;
      edgeInsets.bottom = _infiniteRefreshControl.height;
      [self setContentInset:edgeInsets];
      
      [_infiniteRefreshControl addTarget:self
                                  action:@selector(infiniteValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
    }
    
    _infiniteRefreshBlock = [block copy];
  }
}

- (void)removeInfiniteRefreshControl
{
  [_infiniteRefreshControl removeFromSuperview];
  _infiniteRefreshControl = nil;
  
  UIEdgeInsets edgeInsets = self.contentInset;
  edgeInsets.bottom = 0.0;
  [self setContentInset:edgeInsets];
}



- (void)initialValueChanged:(id)sender
{
  if ( _initialRefreshBlock ) {
    _initialRefreshBlock();
  }
}

- (void)infiniteValueChanged:(id)sender
{
  if ( _infiniteRefreshBlock ) {
    _infiniteRefreshBlock();
  }
}



- (void)layoutSubviews
{
  [super layoutSubviews];
  
  if ( _initialRefreshControl ) {
    [_initialRefreshControl sizeToFit];
    
    CGFloat maxY = 0.0 - _initialRefreshControl.height;
    CGFloat offsetY = self.contentOffset.y;
    
    // At top
    _initialRefreshControl.frame = CGRectMake(0.0, MIN(offsetY, maxY), self.width, _initialRefreshControl.height);
    
    // At middle
    //    if ( offsetY<maxY ) {
    //      _initialRefreshControl.frame = CGRectMake(0.0, (offsetY+maxY)/2.0, self.width, _initialRefreshControl.height);
    //    } else {
    //      _initialRefreshControl.frame = CGRectMake(0.0, maxY, self.width, _initialRefreshControl.height);
    //    }
  }
  
  if ( _infiniteRefreshControl ) {
    
    [_infiniteRefreshControl sizeToFit];
    _infiniteRefreshControl.frame = CGRectMake(0.0, MAX(self.contentSize.height, self.height),
                                               _infiniteRefreshControl.width, _infiniteRefreshControl.height);
    
  }
  
}

@end