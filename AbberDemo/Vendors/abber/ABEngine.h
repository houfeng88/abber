//
//  ABEngine.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "ABCommon.h"
#import "ABStanza.h"

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
  dispatch_queue_t _runLoopQueue;
  
  FMDatabase *_database;
  
  NSMutableArray *_observerAry;
}

+ (void)saveObject:(TKMemoryCache *)object;

+ (ABEngine *)sharedObject;

- (void)prepare;
- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd;
- (void)disconnect;
- (void)stopRunLoop;
- (void)cleanup;

- (NSString *)account;
- (NSString *)password;
- (NSString *)boundJid;

- (ABEngineState)state;
- (BOOL)isDisconnected;
- (BOOL)isConnecting;
- (BOOL)isConnected;


- (ABStanza *)makeStanzaWithName:(NSString *)name;
- (ABStanza *)makeStanzaWithName:(NSString *)name text:(NSString *)text;

- (void)sendData:(NSData *)data;
- (void)sendString:(NSString *)string;

@end
