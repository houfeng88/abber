//
//  ABClient.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>
#import <strophe/hash.h>

typedef enum {
  ABClientStateDisconnected = 0,
  ABClientStateConnecting   = 1,
  ABClientStateConnected    = 2
} ABClientState;

@interface ABClient : NSObject<
    TKObserving
> {
  NSString *_server;
  NSString *_port;
  NSString *_account;
  NSString *_password;
  
  NSMutableArray *_observers;
  
  xmpp_ctx_t *_ctx;
  xmpp_conn_t *_conn;
}

@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy, readonly) NSString *account;
@property (nonatomic, copy, readonly) NSString *password;

+ (ABClient *)sharedObject;


- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd;

- (void)disconnect;

- (ABClientState)state;

@end
