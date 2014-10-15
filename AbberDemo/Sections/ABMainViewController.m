//
//  ABMainViewController.m
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABMainViewController.h"
#import "Common/TKAlertView.h"

#import "ABSessionManager.h"

#import "ABSigninViewController.h"

@implementation ABMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _chatsVC = [[ABChatsViewController alloc] init];
  UINavigationController *chatsNC = [[UINavigationController alloc] initWithRootViewController:_chatsVC];
  chatsNC.navigationBarHidden = YES;
  
  _friendsVC = [[ABFriendsViewController alloc] init];
  UINavigationController *friendsNC = [[UINavigationController alloc] initWithRootViewController:_friendsVC];
  friendsNC.navigationBarHidden = YES;
  
  _moreVC = [[ABMoreViewController alloc] init];
  UINavigationController *moreNC = [[UINavigationController alloc] initWithRootViewController:_moreVC];
  moreNC.navigationBarHidden = YES;
  
  [self setViewControllers:@[ chatsNC, friendsNC, moreNC ] animated:NO];
  
  
  UITabBarItem *item = nil;
  
  item = [self.tabBar.items objectAtIndex:0];
  item.title = NSLocalizedString(@"Chats", @"");
  item.image = TKCreateImage(@"tab_icon_chats.png");
  
  item = [self.tabBar.items objectAtIndex:1];
  item.title = NSLocalizedString(@"Friends", @"");
  item.image = TKCreateImage(@"tab_icon_friends.png");
  
  item = [self.tabBar.items objectAtIndex:2];
  item.title = NSLocalizedString(@"More", @"");
  item.image = TKCreateImage(@"tab_icon_more.png");
  
  
  
  ABEngine *engine = [ABEngine sharedObject];
  
  ABSessionManager *manager = [[ABSessionManager alloc] initWithJid:[engine bareJid]];
  
  _chatsVC.sessionManager = manager;
  _friendsVC.sessionManager = manager;
  _moreVC.sessionManager = manager;
  
  [engine addObserver:_chatsVC];
  [engine addObserver:_friendsVC];
  [engine addObserver:_moreVC];
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
