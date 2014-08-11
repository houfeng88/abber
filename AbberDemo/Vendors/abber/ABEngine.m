//
//  ABEngine.m
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngine.h"
#import "ABLogger.h"

#import "ABEngineConnection.h"

@implementation ABEngine

#pragma mark - Public methods

+ (ABEngine *)sharedObject
{
  static ABEngine *Client = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    Client = [[self alloc] init];
  });
  return Client;
}


- (void)prepare
{
  DDLogDebug(@"[engine] Prepare context");
  if ( [self isDisconnected] ) {
    xmpp_initialize();
    
    
    //_connection = NULL;
    
    _runLoopQueue = dispatch_queue_create("RunLoopQueue", DISPATCH_QUEUE_CONCURRENT);
  }
}

- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd
{
  DDLogDebug(@"[engine] Launch connect");
  if ( [self isConnecting] || [self isConnected] ) {
    return YES;
  }
  
  if ( ABONonempty(acnt) && ABONonempty(pswd) ) {
    xmpp_ctx_t *ctx = xmpp_ctx_new(NULL, &ABDefaultLogger);
    if ( !ctx ) {
      return NO;
    }
    
    _connection = xmpp_conn_new(ctx);
    if ( !_connection ) {
      xmpp_ctx_free(ctx);
      return NO;
    }
    
    xmpp_conn_set_jid(_connection, ABCString(acnt));
    
    xmpp_conn_set_pass(_connection, ABCString(pswd));
    
    dispatch_async(_runLoopQueue, ^{
      [self connectAndRun:_connection];
    });
    
    return YES;
  }
  
  return NO;
}

- (void)disconnect
{
  DDLogDebug(@"[engine] Launch disconnect");
  dispatch_sync(_runLoopQueue, ^{
    xmpp_disconnect(_connection);
  });
}

- (void)stopRunLoop
{
  xmpp_stop(_connection->ctx);
}

- (void)cleanup
{
  DDLogDebug(@"[engine] Cleanup context");
  
  _runLoopQueue = nil;
  
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
    return ABOString(_connection->jid);
  }
  return nil;
}

- (NSString *)password
{
  if ( _connection ) {
    return ABOString(_connection->pass);
  }
  return nil;
}

- (NSString *)boundJid
{
  if ( _connection ) {
    return ABOString(_connection->bound_jid);
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



- (ABStanza *)makeStanza
{
  ABStanza *node = nil;
  if ( (_connection) && (_connection->ctx) ) {
    node = [[ABStanza alloc] init];
    node.stanza = xmpp_stanza_new(_connection->ctx);
  }
  return node;
}

- (void)sendStanza:(ABStanza *)stanza
{
  if ( stanza ) {
    NSData *raw = [stanza raw];
    [self sendRaw:[raw bytes] length:[raw length]];
  }
}

- (void)sendRaw:(const char *)data length:(size_t)length
{
  if ( (data) && (length>0) ) {
    if ( [self isConnected] ) {
      dispatch_sync(_runLoopQueue, ^{
        xmpp_send_raw(_connection, data, length);
        xmpp_debug(_connection->ctx, "conn", "SENT: %s", data);
      });
    }
  }
}


- (NSString *)makeIdentifier:(NSString *)domain suffix:(NSString *)suffix
{
  NSString *identifier = nil;
  if ( ABONonempty(domain) ) {
    
    NSMutableString *rand = [[NSMutableString alloc] init];
    if ( ABONonempty(suffix) ) {
      [rand appendString:suffix];
    }
    [rand appendString:[NSString UUIDString]];
    
    char *string = ABIdentifierCreate(ABCString(domain), ABCString(rand));
    if ( ABCNonempty(string) ) {
      identifier = [[NSString alloc] initWithUTF8String:string];
      free(string);
    }
  }
  return identifier;
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
