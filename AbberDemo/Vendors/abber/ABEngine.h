//
//  ABEngine.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCommon.h"
#import "ABStanza.h"

typedef void (^ABEngineRequestCompletionHandler)(id result, NSError *error);

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
  
  NSMutableArray *_observerAry;
}

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


- (ABStanza *)makeStanza;
- (void)sendStanza:(ABStanza *)stanza;
- (void)sendRaw:(const char *)data length:(size_t)length;

- (NSString *)makeIdentifier:(NSString *)prefix suffix:(NSString *)suffix;

@end


@protocol ABEngineDelegate <NSObject>
@optional

- (void)engineDidStartConnecting:(ABEngine *)engine;
- (void)engine:(ABEngine *)engine didReceiveConnectStatus:(BOOL)status;
- (void)engineDidDisconnected:(ABEngine *)engine;


// { @"jid":@"__", @"name":@"__", @"subscription":@"__" }
- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster;

@end
