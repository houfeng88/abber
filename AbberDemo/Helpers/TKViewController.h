//
//  TKViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKNavigationView.h"

@class TKNavigationView;

@interface TKViewController : UIViewController {
  TKNavigationView *_navigationView;
  UIView *_contentView;
  
  BOOL _viewAppeared;
  NSUInteger _appearedTimes;
}

@property (nonatomic, readonly) BOOL viewAppeared;
@property (nonatomic, readonly) NSUInteger appearedTimes;

- (void)layoutViews;

- (void)backButtonClicked:(id)sender;
- (void)leftButtonClicked:(id)sender;
- (void)rightButtonClicked:(id)sender;

@end
