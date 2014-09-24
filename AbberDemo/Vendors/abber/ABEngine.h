//
//  ABEngine.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCommon.h"
#import "ABContact.h"

typedef void (^ABEngineCompletionHandler)(id result, NSError *error);

typedef enum {
  ABEngineStateDisconnected = 0,
  ABEngineStateConnecting   = 1,
  ABEngineStateConnected    = 2
} ABEngineState;


@interface ABEngine : NSObject<
    TKObserving
> {
  xmpp_conn_t *_connection;
  
  NSMutableArray *_contactAry;
  
  
  NSMutableArray *_observerAry;
}

+ (void)saveObject:(ABEngine *)object;
+ (ABEngine *)sharedObject;

- (void)prepare;
- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd;
- (void)disconnect;
- (void)stopRunLoop;
- (void)cleanup;

- (NSString *)account;
- (NSString *)password;
- (NSString *)bareJid;
- (NSString *)boundJid;

- (ABEngineState)state;
- (BOOL)isDisconnected;
- (BOOL)isConnecting;
- (BOOL)isConnected;

- (void)sendData:(NSData *)data;
- (void)sendString:(NSString *)string;

@end
