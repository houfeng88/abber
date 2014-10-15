//
//  ABChatsViewController.h
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSessionManager.h"

@interface ABChatsViewController : TKTableViewController {
  ABSessionManager *_sessionManager;
  
  NSArray *_sessionAry;
}

@property (nonatomic, strong) ABSessionManager *sessionManager;

@end
