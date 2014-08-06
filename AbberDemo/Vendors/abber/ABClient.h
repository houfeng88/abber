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


@interface ABClient : NSObject<
    TKObserving
> {
  NSString *_server;
  NSString *_port;
  
  xmpp_ctx_t *_ctx;
  xmpp_conn_t *_conn;
}

@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *port;

+ (void)saveObject:(ABClient *)object;

+ (ABClient *)sharedObject;

- (BOOL)connectWithPassport:(NSString *)pspt password:(NSString *)pswd;
- (void)disconnect;

- (NSString *)passport;

- (NSString *)password;

@end
