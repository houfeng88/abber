//
//  ABClient.m
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABClient.h"
#include <strophe/common.h>
#import "internal/logger.h"

int ab_roster_handler(xmpp_conn_t * const conn,
                      xmpp_stanza_t * const stanza,
                      void * const userdata)
{
  xmpp_stanza_t *query, *item;
  char *type, *name;
  
  type = xmpp_stanza_get_type(stanza);
  if (strcmp(type, "error") == 0)
    fprintf(stderr, "ERROR: query failed\n");
  else {
    query = xmpp_stanza_get_child_by_name(stanza, "query");
    printf("Roster:\n");
    for (item = xmpp_stanza_get_children(query); item;
         item = xmpp_stanza_get_next(item))
	    if ((name = xmpp_stanza_get_attribute(item, "name")))
        printf("\t %s (%s) sub=%s\n",
               name,
               xmpp_stanza_get_attribute(item, "jid"),
               xmpp_stanza_get_attribute(item, "subscription"));
	    else
        printf("\t %s sub=%s\n",
               xmpp_stanza_get_attribute(item, "jid"),
               xmpp_stanza_get_attribute(item, "subscription"));
    printf("END OF LIST\n");
  }
  
  /* disconnect */
  //xmpp_disconnect(conn);
  
  return 0;
}

void ab_connection_handler(xmpp_conn_t * const conn,
                           const xmpp_conn_event_t status,
                           const int error,
                           xmpp_stream_error_t * const stream_error,
                           void * const userdata)
{
  xmpp_ctx_t *ctx = (xmpp_ctx_t *)userdata;
  
  if (status == XMPP_CONN_CONNECT) {
    fprintf(stderr, "DEBUG: connected\n");
  } else {
    fprintf(stderr, "DEBUG: disconnected\n");
    xmpp_stop(ctx);
  }
}



@implementation ABClient

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

+ (ABClient *)sharedObject
{
  static ABClient *Client = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    Client = [[self alloc] init];
  });
  return Client;
}


- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd
{
  if ( [acnt length]<=0 ) {
    return NO;
  }
  
  if ( [pswd length]<=0 ) {
    return NO;
  }
  
  
  if ( [self state]!=ABClientStateDisconnected ) {
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
  
  xmpp_conn_set_jid(_conn, [acnt UTF8String]);
  _account = [acnt copy];
  
  xmpp_conn_set_pass(_conn, [pswd UTF8String]);
  _password = [pswd copy];
  
  [self performSelector:@selector(connectAndRun)
               onThread:[[self class] workingThread]
             withObject:nil
          waitUntilDone:NO];
  
  return YES;
}

- (void)disconnect
{
  if ( [self state]!=ABClientStateDisconnected ) {
    xmpp_disconnect(_conn);
    DDLogDebug(@"[client] Launch disconnect");
  }
}

- (ABClientState)state
{
  if ( _conn ) {
    if ( _conn->state==XMPP_STATE_DISCONNECTED ) {
      return ABClientStateDisconnected;
    } else if ( _conn->state==XMPP_STATE_CONNECTING ) {
      return ABClientStateConnecting;
    } else if ( _conn->state==XMPP_STATE_CONNECTED ) {
      return ABClientStateConnected;
    }
  }
  
  return ABClientStateDisconnected;
}


- (void)requestRoster
{
//  <iq from='juliet@example.com/balcony'
//      id='bv1bs71f'
//      type='get'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  
  if ( [self state]==ABClientStateConnected ) {
    xmpp_id_handler_add(_conn, ab_roster_handler, "ROSTER_1", _ctx);
    
    
    xmpp_stanza_t *iq = xmpp_stanza_new(_ctx);
    xmpp_stanza_set_name(iq, "iq");
    xmpp_stanza_set_attribute(iq, "from", [_account UTF8String]);
    xmpp_stanza_set_attribute(iq, "id", "ROSTER_1");
    xmpp_stanza_set_attribute(iq, "type", "get");
    
    xmpp_stanza_t *query = xmpp_stanza_new(_ctx);
    xmpp_stanza_set_name(query, "query");
    xmpp_stanza_set_ns(query, XMPP_NS_ROSTER);
    xmpp_stanza_add_child(iq, query);
    xmpp_stanza_release(query);
    
    xmpp_send(_conn, iq);
    xmpp_stanza_release(iq);
  }
}


#pragma mark - Private methods

- (void)connectAndRun
{
  const char *server = [_server UTF8String];
  
  unsigned short port = [_port intValue];
  
  if ( xmpp_connect_client(_conn, server, port, ab_connection_handler, _ctx)==0 ) {
    xmpp_run(_ctx);
    DDLogDebug(@"[client] Run loop did end");
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
  if ( !_observers ) {
    _observers = [[NSMutableArray alloc] init];
  }
  return _observers;
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
  _observers = nil;
}

@end
