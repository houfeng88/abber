//
//  ABEngine.m
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngine.h"
#include "internal/abcommon.h"
#include "internal/abhandler.h"
#include "internal/ablogger.h"
#include "internal/abrawdata.h"

@implementation ABEngine

#pragma mark - Memory management

- (id)init
{
  self = [super init];
  if (self) {
    xmpp_initialize();
  }
  return self;
}

- (void)dealloc
{
  xmpp_shutdown();
}



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


- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd
{
  if ( [acnt length]<=0 ) return NO;
  
  if ( [pswd length]<=0 ) return NO;
  
  
  if ( [self isConnecting] || [self isConnected] ) {
    return YES;
  }
  
  
  _ctx = xmpp_ctx_new(NULL, &ab_default_logger);
  if ( !_ctx ) {
    return NO;
  }
  
  _conn = xmpp_conn_new(_ctx);
  if ( !_conn ) {
    xmpp_ctx_free(_ctx);
    _ctx = NULL;
    return NO;
  }
  
  xmpp_conn_set_jid(_conn, AB_CSTR(acnt));
  _account = [acnt copy];
  
  xmpp_conn_set_pass(_conn, AB_CSTR(pswd));
  _password = [pswd copy];
  
  [self performSelector:@selector(connectAndRun)
               onThread:[[self class] workingThread]
             withObject:nil
          waitUntilDone:NO];
  
  return YES;
}

- (void)disconnect
{
  if ( [self isConnecting] || [self isConnected] ) {
    
    char *cmd = "</stream:stream>";
    [self sendRaw:cmd length:strlen(cmd)];
    
    DDLogDebug(@"[client] Launch disconnect");
  }
}

- (ABEngineState)state
{
  if ( _conn ) {
    if ( _conn->state==XMPP_STATE_DISCONNECTED ) {
      return ABEngineStateDisconnected;
    } else if ( _conn->state==XMPP_STATE_CONNECTING ) {
      return ABEngineStateConnecting;
    } else if ( _conn->state==XMPP_STATE_CONNECTED ) {
      return ABEngineStateConnected;
    }
  }
  
  return ABEngineStateDisconnected;
}

- (BOOL)isDisconnected
{
  return ( (_conn) && (_conn->state==XMPP_STATE_DISCONNECTED) );
}

- (BOOL)isConnecting
{
  return ( (_conn) && (_conn->state==XMPP_STATE_CONNECTING) );
}

- (BOOL)isConnected
{
  return ( (_conn) && (_conn->state==XMPP_STATE_CONNECTED) );
}


- (void)requestVcard:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id="32cb7637-8bdc-4a53-afb7-d6f30f2a841d"
//      type="get">
//    <vCard xmlns="vcard-temp"/>
//  </iq>
  
  if ( [self isConnected] ) {
    
    char *identifier = ab_create_jid_identifier("vcard", _conn->jid);
    
    xmpp_id_handler_add(_conn, ab_vcard_handler, identifier, NULL);
    
    
    xmpp_stanza_t *iq = xmpp_stanza_new(_ctx);
    xmpp_stanza_set_name(iq, "iq");
    xmpp_stanza_set_attribute(iq, "from", _conn->bound_jid);
    xmpp_stanza_set_attribute(iq, "id", identifier);
    xmpp_stanza_set_attribute(iq, "type", "get");
    
    if ( [jid length]>0 ) {
      xmpp_stanza_set_attribute(iq, "to", AB_CSTR(jid));
    } else {
      xmpp_stanza_set_attribute(iq, "to", AB_CSTR(_account));
    }
    
    xmpp_stanza_t *query = xmpp_stanza_new(_ctx);
    xmpp_stanza_set_name(query, "vCard");
    xmpp_stanza_set_ns(query, "vcard-temp");
    xmpp_stanza_add_child(iq, query);
    xmpp_stanza_release(query);
    
    [self sendStanza:iq];
    xmpp_stanza_release(iq);
    
    if ( identifier ) {
      free(identifier);
    }
  }
}


- (void)requestRoster
{
//  <iq from='juliet@example.com/balcony'
//      id='bv1bs71f'
//      type='get'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  
  if ( [self isConnected] ) {
    char *identifier = ab_create_rand_identifier("roster");
    
    xmpp_id_handler_add(_conn, ab_roster_handler, identifier, _ctx);
    
    
    xmpp_stanza_t *iq = xmpp_stanza_new(_ctx);
    xmpp_stanza_set_name(iq, "iq");
    xmpp_stanza_set_attribute(iq, "from", _conn->bound_jid);
    xmpp_stanza_set_attribute(iq, "id", identifier);
    xmpp_stanza_set_attribute(iq, "type", "get");
    
    xmpp_stanza_t *query = xmpp_stanza_new(_ctx);
    xmpp_stanza_set_name(query, "query");
    xmpp_stanza_set_ns(query, XMPP_NS_ROSTER);
    xmpp_stanza_add_child(iq, query);
    xmpp_stanza_release(query);
    
    [self sendStanza:iq];
    xmpp_stanza_release(iq);
    
    if ( identifier ) {
      free(identifier);
    }
  }
}


#pragma mark - Private methods

- (void)connectAndRun
{
  if ( xmpp_connect_client(_conn, AB_CSTR(_server), [_port intValue], ab_connection_handler, (__bridge void *)self)==0 ) {
    
    if ( _ctx->loop_status==XMPP_LOOP_NOTSTARTED ) {
      
      _ctx->loop_status = XMPP_LOOP_RUNNING;
      
      while ( _ctx->loop_status==XMPP_LOOP_RUNNING ) {
        
        xmpp_run_once(_ctx, 1);
        
        [_sendQueueLock lock];
        rawdata_t *head = (rawdata_t *)_sendQueue;
        _sendQueue = NULL;
        while ( head ) {
          rawdata_t *next = head->next;
          
          xmpp_send_raw(_conn, head->data, head->length);
          xmpp_debug(_ctx, "conn", "SENT: %s", head->data);
          ab_destroy_rawdata(head);
          
          head = next;
        }
        [_sendQueueLock unlock];
      }
      
      xmpp_debug(_ctx, "event", "Event loop completed.");
    }
    
  }
  
  [self clearConnection];
}


- (void)clearConnection
{
  DDLogDebug(@"[client] Clear connection");
  if ( _conn ) {
    xmpp_conn_release(_conn);
    _conn = NULL;
  }
  
  if ( _ctx ) {
    xmpp_ctx_free(_ctx);
    _ctx = NULL;
  }
}


- (void)sendStanza:(xmpp_stanza_t *)stanza
{
  if ( [self isConnected] ) {
    char *buffer;
    size_t length;
    if ( xmpp_stanza_to_text(stanza, &buffer, &length)==0 ) {
      [self sendRaw:buffer length:length];
      xmpp_free(_ctx, buffer);
    }
  }
}

- (void)sendRaw:(const char *)data length:(size_t)length
{
  if ( [self isConnected] ) {
    if ( !_sendQueueLock ) {
      _sendQueueLock = [[NSLock alloc] init];
    }
    [_sendQueueLock lock];
    ab_enqueue((rawdata_t **)(&_sendQueue), ab_create_rawdata(data, length));
    [_sendQueueLock unlock];
  }
}



#pragma mark - Working thread

+ (NSThread *)workingThread
{
  static NSThread *WorkingThread = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    WorkingThread = [[NSThread alloc] initWithTarget:self
                                            selector:@selector(threadBody:)
                                              object:nil];
    [WorkingThread start];
  });
  return WorkingThread;
}

+ (void)threadBody:(id)object
{
  while ( YES ) {
    @autoreleasepool {
      [[NSRunLoop currentRunLoop] run];
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
