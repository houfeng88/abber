//
//  CATransitionExtentions.m
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
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
