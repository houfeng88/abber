//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import "Sections/ABRootViewController.h"
#import "Sections/ABSigninViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self addLoggers];
  [self configStatusBar];
  [self configTapkit];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  
  ABSigninViewController *signin = [[ABSigninViewController alloc] init];
  
  _window.rootViewController = [[ABRootViewController alloc] initWithBodyViewController:signin];
  
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)addLoggers
{
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
  DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
  fileLogger.rollingFrequency = 24*60*60;
  [DDLog addLogger:fileLogger];
}

- (void)configStatusBar
{
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  
  if ( [[[UIDevice currentDevice] systemVersion] floatValue]<7.0 ) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
  } else {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
  }
}

- (void)configTapkit
{
  TKSettings *settings = [[TKSettings alloc] initWithName:@"AppSettings.xml"];
  [TKSettings saveObject:settings];
}

@end
