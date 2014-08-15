//
//  ABRootViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABRootViewController : UIViewController {
  UIViewController *_presentedViewController;
}

- (void)presentWithViewController:(UIViewController *)vc;

- (void)dismissByViewController:(UIViewController *)vc;

@end
