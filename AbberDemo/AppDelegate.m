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
  
  NSString *acnt = @"tkjohn@blah.im/teemo";
  NSString *pswd = @"12345678";
  
  [[ABEngine sharedObject] prepare];
  [[ABEngine sharedObject] connectWithAccount:acnt password:pswd];
}

- (void)update:(id)sender
{
  [[ABEngine sharedObject] updateVcard:@"Kevin" desc:@"It's me."];
}

- (void)request:(id)sender
{
  [[ABEngine sharedObject] disconnect];
  //[[ABEngine sharedObject] sendRaw:"abc" length:3];
  //[[ABEngine sharedObject] requestVcard:nil completion:NULL];
}

@end
