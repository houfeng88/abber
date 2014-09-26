//
//  ABMainViewController.h
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ABChatsViewController.h"
#import "ABFriendsViewController.h"
#import "ABMoreViewController.h"

@interface ABMainViewController : UITabBarController {
  ABChatsViewController *_chatsVC;
  ABFriendsViewController *_friendsVC;
  ABMoreViewController *_moreVC;
}

- (void)presentSignin;

- (void)configEngine;

@end
