//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import <abber/abber.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self addLoggers];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  //NSObject *object = [[NSObject alloc] init];
  //[object string];
  
  DDLogError(@"abc");
  
  ABClient *client = [[ABClient alloc] init];
  [ABClient saveObject:client];
  
  [client performSelector:@selector(launch2) withObject:nil afterDelay:1.0];
  [client performSelector:@selector(launch1) withObject:nil afterDelay:3.0];
  
//  NSString *jid = @"tktony@is-a-furry.org";
//  NSString *pass = @"12345678";
  
//  [[ABClient sharedObject] connectWithPassport:jid
//                                      password:pass
//                                        server:nil
//                                          port:nil];
  
  
  
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
