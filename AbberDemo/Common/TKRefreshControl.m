//
//  TKRefreshControl.m
//  RefreshDemo
//
//  Created by Kevin Wu on 7/17/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKRefreshControl.h"

@implementation TKRefreshControl

- (id)init
{
  self = [super init];
  if ( self ) {
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = NO;
    [_activityIndicatorView stopAnimating];
    [self addSubview:_activityIndicatorView];
    
    _triggered = NO;
    
    
    _refreshing = NO;
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 44.0);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [_activityIndicatorView sizeToFit];
  [_activityIndicatorView moveToCenterOfSuperview];
  
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  if ( newSuperview ) {
    [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    [newSuperview addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:NULL];
  } else {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    [self.superview removeObserver:self forKeyPath:@"pan.state"];
  }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  UIScrollView *scrollView = (UIScrollView *)(self.superview);
  
  if ( [keyPath isEqualToString:@"contentOffset"] ) {
    
    if ( !_refreshing ) {
      
      CGFloat offsetY = scrollView.contentOffset.y;
      CGFloat topY = self.topY;
      
      if ( scrollView.isDragging ) {
        if ( ((offsetY+scrollView.height)-topY)>=(0.6*self.height) ) {
#ifdef DEBUG
          if ( !_triggered ) NSLog(@"triggered");
#endif
          _triggered = YES;
        } else {
#ifdef DEBUG
          if ( _triggered ) NSLog(@"cancel triggered");
#endif
          _triggered = NO;
        }
      } else {
        if ( _triggered ) {
#ifdef DEBUG
          NSLog(@"offset change launch");
#endif
          [self sendActionsForControlEvents:UIControlEventValueChanged];
          [self beginRefreshing];
        }
      }
      
    }
    
  } else if ( [keyPath isEqualToString:@"pan.state"] ) {
    
    if ( !_refreshing ) {
      if ( _triggered ) {
#ifdef DEBUG
        NSLog(@"end drag launch");
#endif
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self beginRefreshing];
      }
    }
    
  } else if ( [keyPath isEqualToString:@"contentSize"] ) {
    
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat height = scrollView.height;
    
    self.frame = CGRectMake(0.0, MAX(contentHeight, height), self.width, self.height);
    
  }
}



- (void)beginRefreshing
{
  [_activityIndicatorView startAnimating];
  //_triggered = NO;
  
  _refreshing = YES;
}

- (void)endRefreshing
{
  [_activityIndicatorView stopAnimating];
  _triggered = NO;
  
  _refreshing = NO;
  
  
  UIScrollView *scrollView = (UIScrollView *)(self.superview);
  
  CGFloat offsetY = scrollView.contentOffset.y;
  CGFloat contentHeight = scrollView.contentSize.height;
  CGFloat scrollViewHeight = scrollView.height;
  if ( (offsetY+scrollViewHeight)>contentHeight ) {
    CGFloat newOffsetY = contentHeight - scrollViewHeight;
    [scrollView setContentOffset:CGPointMake(0.0, MAX(0.0, newOffsetY)) animated:YES];
  }
}

@end
