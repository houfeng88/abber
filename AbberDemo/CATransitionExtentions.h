//
//  CATransitionExtentions.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransition (Extentions)

+ (CATransition *)pushTransition;

+ (CATransition *)popTransition;

@end
