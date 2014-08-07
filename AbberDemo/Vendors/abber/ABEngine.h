//
//  ABEngine.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>

typedef void (^ABEngineRequestCompletionHandler)(id result, NSError *error);

typedef enum {
  ABEngineStateDisconnected = 0,
  ABEngineStateConnecting   = 1,
  ABEngineStateConnected    = 2
} ABEngineState;

@interface ABEngine : NSObject<
    TKObserving
> {
  NSString *_server;
  NSString *_port;
  NSString *_account;
  NSString *_password;
  
  
  NSMutableArray *_observerAry;
  
  
  void *_sendQueue;
  NSLock *_sendQueueLock;
  
  xmpp_ctx_t *_ctx;
  xmpp_conn_t *_conn;
}

@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy, readonly) NSString *account;
@property (nonatomic, copy, readonly) NSString *password;

+ (ABEngine *)sharedObject;


- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd;

- (void)disconnect;

- (ABEngineState)state;
- (BOOL)isDisconnected;
- (BOOL)isConnecting;
- (BOOL)isConnected;

- (void)requestVcard:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler;
- (void)updateVcard:(NSString *)nickname desc:(NSString *)desc;

- (void)requestRoster;

@end
