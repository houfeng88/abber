//
//  ABSessionViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 9/29/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSessionManager.h"
#import "ABMessageInputView.h"

@interface ABSessionViewController : TKViewController<
  UITableViewDataSource,
  UITableViewDelegate
> {
  UITableView *_tableView;
  ABMessageInputView *_inputView;
  
  CGFloat _keyboardHeight;
  
  NSString *_jid;
  NSMutableArray *_messageAry;
}

- (id)initWithJid:(NSString *)jid messageAry:(NSMutableArray *)messageAry;

@end
