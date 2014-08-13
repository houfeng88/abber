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
  button.normalTitle = @"Roster";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(roster:) forControlEvents:UIControlEventTouchUpInside];
  [_window addSubview:button];
  button.frame = CGRectMake(10.0, 80.0, 300.0, 40.0);
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"Presence";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(presence:) forControlEvents:UIControlEventTouchUpInside];
  [_window addSubview:button];
  button.frame = CGRectMake(10.0, 130.0, 300.0, 40.0);
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"doit";
  button.normalTitleColor = [UIColor blackColor];
  button.highlightedTitleColor = [UIColor redColor];
  [button addTarget:self action:@selector(doit:) forControlEvents:UIControlEventTouchUpInside];
  [_window addSubview:button];
  button.frame = CGRectMake(10.0, 180.0, 300.0, 40.0);
  
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
  NSString *acnt = @"tklisa@blah.im/teemo";
  NSString *pswd = @"123456";
  
  [[ABEngine sharedObject] prepare];
  [[ABEngine sharedObject] connectWithAccount:acnt password:pswd];
  [[ABEngine sharedObject] prepareForRosterPush];
}

- (void)roster:(id)sender
{
  [[ABEngine sharedObject] requestRosterWithCompletion:NULL];
}

- (void)presence:(id)sender
{
  [[ABEngine sharedObject] updatePresence:ABPresenceTypeAvailable];
}

- (void)doit:(id)sender
{
  static int i=0;
  i++;
  
  if ( i==1 ) {
    [[ABEngine sharedObject] subscribeContact:@"tkdave@blah.im"];
  } else if ( i==2 ) {
    [[ABEngine sharedObject] removeContact:@"tkdave@blah.im"
                                completion:NULL];
  }
  
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
