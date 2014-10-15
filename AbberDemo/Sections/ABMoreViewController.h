//
//  ABMoreViewController.h
//  AbberDemo
//
//  Created by Kevin on 8/16/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSessionManager.h"

@interface ABMoreViewController : TKTableViewController {
  ABSessionManager *_sessionManager;
  
  ABContact *_user;
}

@property (nonatomic, strong) ABSessionManager *sessionManager;

@end
