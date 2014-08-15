//
//  AppDelegate.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import "ABRootViewController.h"
#import "ABSigninViewController.h"
#import <abber/abber.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self addLoggers];
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  ABRootViewController *root = [[ABRootViewController alloc] init];
  ABSigninViewController *signin = [[ABSigninViewController alloc] init];
  [root presentWithViewController:signin];
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:root];
  nc.navigationBarHidden = YES;
  _window.rootViewController = nc;
  
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
  
  [[ABEngine sharedObject] addObserver:self];
  [[ABEngine sharedObject] prepare];
  [[ABEngine sharedObject] connectWithAccount:acnt password:pswd];
  [[ABEngine sharedObject] prepareForRosterPush];
  [[ABEngine sharedObject] prepareForPresenceUpdate];
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
    [[ABEngine sharedObject] addContact:@"tkdave@blah.im"
                                   name:@"Dave"
                             completion:NULL];
    [[ABEngine sharedObject] subscribeContact:@"tkdave@blah.im"];
  } else if ( i==2 ) {
    [[ABEngine sharedObject] removeContact:@"tkdave@blah.im"
                                completion:NULL];
  }
  
}


- (void)engine:(ABEngine *)engine didReceiveRosterItem:(NSDictionary *)item
{
  NSLog(@"HERE: %s %@", __func__, item);
}

- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster error:(NSError *)error
{
  NSLog(@"HERE: %s %@ %@", __func__, roster, error);
}

- (void)engine:(ABEngine *)engine didChangeContact:(NSString *)jid error:(NSError *)error
{
  NSLog(@"HERE: %s %@ %@", __func__, jid, error);
}

@end
