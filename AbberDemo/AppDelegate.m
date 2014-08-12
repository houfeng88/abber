//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import <abber/abber.h>

#import <abber/ABObject.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self addLoggers];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = @"Start";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
  [_window addSubview:button];
  button.frame = CGRectMake(10.0, 30.0, 300.0, 40.0);
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"Update";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
  [_window addSubview:button];
  button.frame = CGRectMake(10.0, 80.0, 300.0, 40.0);
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"Request";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
  [_window addSubview:button];
  button.frame = CGRectMake(10.0, 130.0, 300.0, 40.0);
  
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


- (void)start:(id)sender
{
//  NSString *acnt = @"tkjohn@is-a-furry.org";
//  NSString *pswd = @"12345678";
  
  NSString *acnt = @"tkcara@blah.im/teemo";
  NSString *pswd = @"123456";
  
  [[ABEngine sharedObject] addObserver:self];
  
  [[ABEngine sharedObject] prepare];
  [[ABEngine sharedObject] connectWithAccount:acnt password:pswd];
}

- (void)update:(id)sender
{
  //[[ABEngine sharedObject] addContact:@"tkjack@blah.im" name:@"Jack" completion:NULL];
  
  static ABPresenceType type = ABPresenceTypeAvailable;
  [[ABEngine sharedObject] updatePresence:type];
  type++;
  if ( type>5 ) {
    type=0;
  }
}

- (void)request:(id)sender
{
}


- (void)engineDidStartConnecting:(ABEngine *)engine
{
  NSLog(@"HERE: %s", __func__);
}

- (void)engine:(ABEngine *)engine didReceiveConnectStatus:(BOOL)status
{
  NSLog(@"HERE: %s %d", __func__, status);
}

- (void)engineDidDisconnected:(ABEngine *)engine
{
  NSLog(@"HERE: %s", __func__);
}


- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster
{
  NSLog(@"HERE: %s %@", __func__, roster);
}

@end
