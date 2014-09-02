//
//  ABEngine.m
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngine.h"
#import "ABConfig.h"
#import "ABEngineConnection.h"

@implementation ABEngine

#pragma mark - Public methods

static ABEngine *Engine = nil;

+ (void)saveObject:(ABEngine *)object
{
  Engine = object;
}

+ (ABEngine *)sharedObject
{
  return Engine;
}


- (void)prepare
{
  DDLogDebug(@"[engine] Prepare context");
  if ( [self isDisconnected] ) {
    
    xmpp_initialize();
    
  }
}

- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd
{
  DDLogDebug(@"[engine] Launch connect");
  if ( [self isConnecting] || [self isConnected] ) {
    return YES;
  }
  
  if ( TKSNonempty(acnt) && TKSNonempty(pswd) ) {
    
    xmpp_ctx_t *ctx = xmpp_ctx_new(NULL, &ABDefaultLogger);
    if ( !ctx ) {
      return NO;
    }
    
    _connection = xmpp_conn_new(ctx);
    if ( !_connection ) {
      xmpp_ctx_free(ctx);
      return NO;
    }
    
    
    NSString *jid = ABJidCreate(acnt, ABJabberDomain, ABJabberResource);
    xmpp_conn_set_jid(_connection, TKCString(jid));
    
    xmpp_conn_set_pass(_connection, TKCString(pswd));
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
      [self connectAndRun];
    });
    
    return YES;
  }
  
  return NO;
}

- (void)disconnect
{
  DDLogDebug(@"[engine] Launch disconnect");
  xmpp_disconnect(_connection);
}

- (void)stopRunLoop
{
  DDLogDebug(@"[engine] Launch stop run loop");
  
  xmpp_stop(_connection->ctx);
}

- (void)cleanup
{
  DDLogDebug(@"[engine] Cleanup context");
  
  if ( _connection ) {
    xmpp_ctx_t *ctx = _connection->ctx;
    xmpp_conn_release(_connection);
    _connection = NULL;
    if ( ctx ) {
      xmpp_ctx_free(ctx);
    }
  }
  
  xmpp_shutdown();
}


- (NSString *)account
{
  if ( _connection ) {
    return ABJidNode(TKOString(_connection->bound_jid));
  }
  return nil;
}

- (NSString *)password
{
  if ( _connection ) {
    return TKOString(_connection->pass);
  }
  return nil;
}

- (NSString *)bareJid
{
  if ( _connection ) {
    return ABJidBare(TKOString(_connection->bound_jid));
  }
  return nil;
}

- (NSString *)boundJid
{
  if ( _connection ) {
    return TKOString(_connection->bound_jid);
  }
  return nil;
}


- (ABEngineState)state
{
  if ( _connection ) {
    xmpp_conn_state_t state = _connection->state;
    if ( state==XMPP_STATE_DISCONNECTED ) {
      return ABEngineStateDisconnected;
    } else if ( state==XMPP_STATE_CONNECTING ) {
      return ABEngineStateConnecting;
    } else if ( state==XMPP_STATE_CONNECTED ) {
      return ABEngineStateConnected;
    }
  }
  
  return ABEngineStateDisconnected;
}

- (BOOL)isDisconnected
{
  return ( (_connection==NULL) || (_connection->state==XMPP_STATE_DISCONNECTED) );
}

- (BOOL)isConnecting
{
  return ( (_connection) && (_connection->state==XMPP_STATE_CONNECTING) );
}

- (BOOL)isConnected
{
  return ( (_connection) && (_connection->state==XMPP_STATE_CONNECTED) );
}


- (void)sendData:(NSData *)data
{
  if ( [self isConnected] ) {
    if ( TKDNonempty(data) ) {
      xmpp_send_raw(_connection, [data bytes], [data length]);
      xmpp_debug(_connection->ctx, "conn", "SENT: %s", [data bytes]);
    }
  }
}

- (void)sendString:(NSString *)string
{
  if ( [self isConnected] ) {
    if ( TKSNonempty(string) ) {
      xmpp_send_raw(_connection, [string UTF8String], [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
      xmpp_debug(_connection->ctx, "conn", "SENT: %s", [string UTF8String]);
    }
  }
}



#pragma mark - TKObserving

- (NSArray *)observers
{
  if ( !_observerAry ) {
    _observerAry = [[NSMutableArray alloc] init];
  }
  return _observerAry;
}

- (id)addObserver:(id)observer
{
  NSMutableArray *observerAry = (NSMutableArray *)[self observers];
  return [observerAry addUnidenticalObjectIfNotNil:observer];
}

- (void)removeObserver:(id)observer
{
  NSMutableArray *observerAry = (NSMutableArray *)[self observers];
  [observerAry removeObjectIdenticalTo:observer];
}

- (void)removeAllObservers
{
  _observerAry = nil;
}

@end
