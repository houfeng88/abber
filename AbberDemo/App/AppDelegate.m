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
  [self configEngine];
  
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

- (void)configEngine
{
  [[ABEngine sharedObject] addObserver:self];
}


#pragma mark - ABEngineDelegate

- (void)engine:(ABEngine *)engine didReceiveRosterItem:(NSDictionary *)item
{
}

- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster error:(NSError *)error
{
  NSArray *jidAry = [roster valueForKeyPath:@"@unionOfObjects.jid"];
  
  NSArray *savedAry = [[TKDatabase sharedObject] executeQuery:@"SELECT * FROM contact;"];
  for ( TKDatabaseRow *row in savedAry ) {
    NSString *jid = [row stringForName:@"jid"];
    if ( ![jidAry containsObject:jid] ) {
      [[TKDatabase sharedObject] executeUpdate:@"DELETE FROM contact WHERE jid=?;", jid];
    }
  }
  
  
  for ( NSDictionary *item in roster ) {
    
    NSString *ask = [item objectForKey:@"ask"];
    NSString *jid = [item objectForKey:@"jid"];
    NSString *nickname = [item objectForKey:@"name"];
    NSString *subscription = [item objectForKey:@"subscription"];
    
    ABSubscriptionType relation = ABSubscriptionTypeNone;
    if ( [subscription isEqualToString:@"none"] ) {
      relation = ((!ABOSNonempty(ask)) ? ABSubscriptionTypeNone : ABSubscriptionTypeNoneOut);
    } else if ( [subscription isEqualToString:@"to"] ) {
      relation = ((!ABOSNonempty(ask)) ? ABSubscriptionTypeTo : ABSubscriptionTypeToIn);
    } else if ( [subscription isEqualToString:@"from"] ) {
      relation = ((!ABOSNonempty(ask)) ? ABSubscriptionTypeFrom : ABSubscriptionTypeFromOut);
    } else if ( [subscription isEqualToString:@"both"] ) {
      relation = ABSubscriptionTypeBoth;
    }
    
    
    if ( [[TKDatabase sharedObject] executeQuery:@"SELECT * FROM contact WHERE jid=?;", jid] ) {
      [[TKDatabase sharedObject] executeUpdate:@"UPDATE contact SET nickname=?, relation=? WHERE jid=?;", nickname, @(relation), jid];
    } else {
      [[TKDatabase sharedObject] executeUpdate:@"INSERT INTO contact(jid, nickname, relation) VALUES(?, ?, ?);", jid, nickname, @(relation)];
    }
  }
}

@end
