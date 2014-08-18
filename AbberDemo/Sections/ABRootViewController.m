//
//  ABRootViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABRootViewController.h"

@implementation ABRootViewController

- (id)initWithBodyViewController:(UIViewController *)vc
{
  self = [super init];
  if (self) {
    if ( [[[UIDevice currentDevice] systemVersion] floatValue]<7.0 ) {
      self.wantsFullScreenLayout = YES;
    }
    
    _bodyViewController = vc;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView = [[UIImageView alloc] init];
  _navigationView.backgroundColor = [UIColor clearColor];
  _navigationView.contentMode = UIViewContentModeScaleToFill;
  _navigationView.image = TKCreateResizableImage(@"navbar_bg.png", UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0));
  [self.view addSubview:_navigationView];
  
  [self presentChildViewController:_bodyViewController inView:self.view];
}


- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  [self layoutViews];
}

- (void)layoutViews
{
  _navigationView.frame = CGRectMake(0.0, 0.0, self.view.width, 64.0);
  _bodyViewController.view.frame = self.view.bounds;
}


- (void)presentWithViewController:(UIViewController *)vc
{
  [self presentChildViewController:vc inView:self.view];
  vc.view.frame = CGRectMake(self.view.width, 0.0, self.view.width, self.view.height);
  
  
  UIView *nextView = vc.view;
  
  CGPoint toPoint = CGPointMake(self.view.width/2.0, self.view.height/2.0);
  CABasicAnimation *transition = [self positionAnimationFrom:nextView.center to:toPoint];
  
  CAAnimationGroup *nextViewAnimation = [CAAnimationGroup animation];
  nextViewAnimation.animations = @[ transition ];
  [nextView.layer addAnimation:nextViewAnimation forKey:nil];
  
  
  UIView *currentView = _bodyViewController.view;
  
  toPoint = CGPointMake(0.0-(self.view.width/2.0), self.view.height/2.0);
  transition = [self positionAnimationFrom:currentView.center to:toPoint];
  
  CAAnimationGroup *currentViewAnimation = [CAAnimationGroup animation];
  currentViewAnimation.animations = @[ transition ];
  [currentView.layer addAnimation:currentViewAnimation forKey:nil];
  
  
  [self dismissChildViewController:_bodyViewController];
  
  _bodyViewController = vc;
  
  [self layoutViews];
}

- (void)dismissByViewController:(UIViewController *)vc
{
  [self presentChildViewController:vc inView:self.view];
  vc.view.frame = CGRectMake(0.0-self.view.width, 0.0, self.view.width, self.view.height);
  
  
  UIView *nextView = vc.view;
  
  CGPoint toPoint = CGPointMake(self.view.width/2.0, self.view.height/2.0);
  CABasicAnimation *transition = [self positionAnimationFrom:nextView.center to:toPoint];
  
  CAAnimationGroup *nextViewAnimation = [CAAnimationGroup animation];
  nextViewAnimation.animations = @[ transition ];
  [nextView.layer addAnimation:nextViewAnimation forKey:nil];
  
  
  UIView *currentView = _bodyViewController.view;
  
  toPoint = CGPointMake(self.view.width/2.0*3, self.view.height/2.0);
  transition = [self positionAnimationFrom:currentView.center to:toPoint];
  
  CAAnimationGroup *currentViewAnimation = [CAAnimationGroup animation];
  currentViewAnimation.animations = @[ transition ];
  [currentView.layer addAnimation:currentViewAnimation forKey:nil];
  
  
  [self dismissChildViewController:_bodyViewController];
  
  _bodyViewController = vc;
  
  [self layoutViews];
}


- (CABasicAnimation *)opacityAnimation:(BOOL)fadeIn
{
  CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  opacityAnimation.fromValue = [NSNumber numberWithFloat:(fadeIn?0.0:1.0)];
  opacityAnimation.toValue = [NSNumber numberWithFloat:(fadeIn?1.0:0.0)];
  return opacityAnimation;
}

- (CABasicAnimation *)positionAnimationFrom:(CGPoint)fromPoint to:(CGPoint)toPoint
{
  CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
  positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
  positionAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
  return positionAnimation;
}

@end
