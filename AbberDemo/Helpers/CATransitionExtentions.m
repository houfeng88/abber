//
//  CATransitionExtentions.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "CATransitionExtentions.h"

@implementation CATransition (Extentions)

+ (CATransition *)pushTransition
{
  CATransition *transition = [CATransition animation];
  transition.duration = 0.45;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
  transition.type = kCATransitionFromRight;
  [transition setType:kCATransitionPush];
  transition.subtype = kCATransitionFromRight;
  return transition;
}

+ (CATransition *)popTransition
{
  CATransition *transition = [CATransition animation];
  transition.duration = 0.45;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
  transition.type = kCATransitionFromLeft;
  [transition setType:kCATransitionPush];
  transition.subtype = kCATransitionFromLeft;
  return transition;
}

@end
