//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import "roster.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self addLoggers];
  
  roster();
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  NSArray *ary = @[ @"A", @"B" ];
  NSLog(@"%@", [ary objectOrNilAtIndex:0]);
  
  //NSObject *object = [[NSObject alloc] init];
  //[object string];
  
  DDLogError(@"abc");
  
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

@end
