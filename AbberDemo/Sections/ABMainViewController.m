//
//  ABMainViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMainViewController.h"

#import "ABChatsViewController.h"
#import "ABFriendsViewController.h"
#import "ABFindViewController.h"
#import "ABMoreViewController.h"

#import "ABSigninViewController.h"

#import "General/TKAlertView.h"

@implementation ABMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  ABChatsViewController *chats = [[ABChatsViewController alloc] init];
  UINavigationController *chatsNC = [[UINavigationController alloc] initWithRootViewController:chats];
  chatsNC.navigationBarHidden = YES;
  
  ABFriendsViewController *friends = [[ABFriendsViewController alloc] init];
  UINavigationController *friendsNC = [[UINavigationController alloc] initWithRootViewController:friends];
  friendsNC.navigationBarHidden = YES;
  
  ABFindViewController *find = [[ABFindViewController alloc] init];
  UINavigationController *findNC = [[UINavigationController alloc] initWithRootViewController:find];
  findNC.navigationBarHidden = YES;
  
  ABMoreViewController *more = [[ABMoreViewController alloc] init];
  UINavigationController *moreNC = [[UINavigationController alloc] initWithRootViewController:more];
  moreNC.navigationBarHidden = YES;
  
  [self setViewControllers:@[ chatsNC, friendsNC, findNC, moreNC ] animated:NO];
  
  
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

- (void)presentSignin
{
  ABSigninViewController *signin = [[ABSigninViewController alloc] init];
  [self presentChildViewController:signin inView:self.view];
  signin.view.frame = self.view.bounds;
}


- (void)engine:(ABEngine *)engine didReceiveFriendRequest:(NSString *)jid
{
  NSString *fmt = NSLocalizedString(@"Would you accept %@?", @"");
  NSString *message = [[NSString alloc] initWithFormat:fmt, jid];
  TKAlertView *av = [[TKAlertView alloc] initWithTitle:NSLocalizedString(@"Friend Request", @"")
                                               message:message];
  [av addButtonWithTitle:NSLocalizedString(@"Accept", @"") block:^{
    [[ABEngine sharedObject] subscribedContact:jid];
    [[ABEngine sharedObject] subscribeContact:jid];
  }];
  [av addCancelButtonWithTitle:NSLocalizedString(@"Decline", @"") block:^{
    [[ABEngine sharedObject] unsubscribedContact:jid];
  }];
  [av show];
}

@end
