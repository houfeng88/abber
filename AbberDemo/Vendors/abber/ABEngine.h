//
//  ABEngine.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>
#import "ABStanza.h"
#import "ABConfig.h"

typedef void (^ABEngineRequestCompletionHandler)(id result, NSError *error);

typedef enum {
  ABEngineStateDisconnected = 0,
  ABEngineStateConnecting   = 1,
  ABEngineStateConnected    = 2
} ABEngineState;

@interface ABEngine : NSObject<
    TKObserving
> {
  xmpp_conn_t *_conn;
  
  NSString *_account;
  NSString *_password;
  
  void *_sendQueue;
  NSLock *_sendQueueLock;
  
  NSMutableArray *_observerAry;
}

@property (nonatomic, copy, readonly) NSString *account;
@property (nonatomic, copy, readonly) NSString *password;

+ (ABEngine *)sharedObject;

- (void)prepare;
- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd;
- (void)disconnect;
- (void)cleanup;

- (ABEngineState)state;
- (BOOL)isDisconnected;
- (BOOL)isConnecting;
- (BOOL)isConnected;

- (void)requestVcard:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler;
- (void)updateVcard:(NSString *)nickname desc:(NSString *)desc;

- (void)requestRoster;


- (ABStanza *)makeStanza;

- (NSString *)makeIdentifier:(NSString *)prefix suffix:(NSString *)suffix;

@end
