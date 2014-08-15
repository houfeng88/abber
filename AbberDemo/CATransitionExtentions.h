//
//  CATransitionExtentions.h
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CATransition (Extentions)

+ (CATransition *)pushTransition;

+ (CATransition *)popTransition;

@end
