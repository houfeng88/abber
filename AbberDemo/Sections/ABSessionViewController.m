//
//  ABSessionViewController.m
//  AbberDemo
//
//  Created by Kevin Wu on 9/29/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSessionViewController.h"
#import "ABMessageCell.h"

@implementation ABSessionViewController

- (id)initWithJid:(NSString *)jid messageAry:(NSMutableArray *)messageAry
{
  self = [super init];
  if (self) {
    self.hidesBottomBarWhenPushed = YES;
    
    [[ABEngine sharedObject] addObserver:self];
    
    _jid = jid;
    _messageAry = messageAry;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = _jid;
  
  _tableView = [[TKTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [_contentView addSubview:_tableView];
  
  _inputView = [[ABMessageInputView alloc] init];
  [_inputView.button addTarget:self
                        action:@selector(sendButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:_inputView];
  
  
  [self addResignGestureInView:_tableView];
}

- (void)layoutViews
{
  [super layoutViews];
  
  [_inputView sizeToFit];
  _inputView.frame = CGRectMake(0.0, _contentView.height-_keyboardHeight-_inputView.height, _contentView.width, _inputView.height);
  
  _tableView.frame = CGRectMake(0.0, 0.0, _contentView.width, _inputView.topY);
}


- (void)engine:(ABEngine *)engine didReceiveMessage:(ABMessage *)message
{
  [_tableView reloadData];
  [_tableView scrollToBottomAnimated:YES];
}


- (void)sendButtonClicked:(id)sender
{
  NSString *content = _inputView.textField.text;
  _inputView.textField.text = nil;
  
  if ( TKSNonempty(content) ) {
    ABMessage *message = [[ABMessage alloc] init];
    message.to = _jid;
    message.type = ABMessageText;
    message.content = content;
    [[ABEngine sharedObject] sendMessage:message];
    
    [_messageAry addObject:message];
    [_tableView reloadData];
    [_tableView scrollToBottomAnimated:YES];
  }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
  NSDictionary *userInfo = [noti userInfo];
  NSValue *keyboardFrameBegin = [userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
  CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
  
  _keyboardHeight = keyboardFrameBeginRect.size.height;
  
  [self layoutViews];
  [_tableView scrollToBottomAnimated:YES];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
  _keyboardHeight = 0.0;
  
  [self layoutViews];
  [_tableView scrollToBottomAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_messageAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABMessageCell *cell = (ABMessageCell *)[tableView dequeueReusableCellWithClass:[ABMessageCell class]];
  
  
  ABMessage *message = [_messageAry objectAtIndex:indexPath.row];
  
  [cell updateWithMessage:message];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ABMessage *message = [_messageAry objectAtIndex:indexPath.row];
  
  return [ABMessageCell heightForTableView:tableView object:message];
}

@end
