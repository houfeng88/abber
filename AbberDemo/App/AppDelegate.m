//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"

#import "Sections/ABMainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self configLoggers];
  [self configStatusBar];
  [self configTapkit];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  ABMainViewController *main = [[ABMainViewController alloc] init];
  _window.rootViewController = main;
  [main presentSignin];
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)configLoggers
{
  DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
  [DDLog addLogger:ttyLogger];
  
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
  NSString *path = TKPathForDocumentResource(@"AppSettings.xml");
  TKSettings *settings = [[TKSettings alloc] initWithPath:path];
  [TKSettings saveObject:settings];
}

@end
