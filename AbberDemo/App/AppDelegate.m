//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"

#import "Sections/ABSigninViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self configLoggers];
  [self configStatusBar];
  [self configTapkit];
  
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _window.rootViewController = [[ABSigninViewController alloc] init];
  
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
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)configTapkit
{
  NSString *path = TKPathForDocumentResource(@"AppSettings.xml");
  TKSettings *settings = [[TKSettings alloc] initWithPath:path];
  [TKSettings saveObject:settings];
}

@end
