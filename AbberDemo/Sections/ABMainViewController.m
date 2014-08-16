//
//  ABMainViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMainViewController.h"
#import "ABRootViewController.h"
#import "ABSigninViewController.h"

#import "ABChatsViewController.h"
#import "ABFriendsViewController.h"
#import "ABFindViewController.h"
#import "ABMoreViewController.h"

@implementation ABMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  ABChatsViewController *chats = [[ABChatsViewController alloc] init];
  ABFriendsViewController *friends = [[ABFriendsViewController alloc] init];
  ABFindViewController *find = [[ABFindViewController alloc] init];
  ABMoreViewController *more = [[ABMoreViewController alloc] init];
  
  [self setViewControllers:@[ chats, friends, find, more ] animated:NO];
  
  
  UITabBarItem *item = nil;
  
  item = [self.tabBar.items objectAtIndex:0];
  item.title = NSLocalizedString(@"Chats", @"");
  item.image = TKCreateImage(@"tab_icon_chats.png");
  
  item = [self.tabBar.items objectAtIndex:1];
  item.title = NSLocalizedString(@"Friends", @"");
  item.image = TKCreateImage(@"tab_icon_friends.png");
  
  item = [self.tabBar.items objectAtIndex:2];
  item.title = NSLocalizedString(@"Find", @"");
  item.image = TKCreateImage(@"tab_icon_find.png");
  
  item = [self.tabBar.items objectAtIndex:3];
  item.title = NSLocalizedString(@"More", @"");
  item.image = TKCreateImage(@"tab_icon_more.png");
  
}

@end
