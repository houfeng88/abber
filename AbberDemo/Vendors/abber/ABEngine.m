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
    
    //_conn = NULL;
    
    //_account = nil;
    //_password = nil;
    
    //_sendQueue = NULL;
    _sendQueueLock = [[NSLock alloc] init];
  }
}

- (BOOL)connectWithAccount:(NSString *)acnt password:(NSString *)pswd
{
  DDLogDebug(@"[engine] Launch connect");
  if ( [self isConnecting] || [self isConnected] ) {
    return YES;
  }
  
  if ( ABONonempty(acnt) && ABONonempty(pswd) ) {
    xmpp_ctx_t *ctx = xmpp_ctx_new(NULL, &ab_default_logger);
    if ( !ctx ) {
      return NO;
    }
    
    _conn = xmpp_conn_new(ctx);
    if ( !_conn ) {
      xmpp_ctx_free(ctx);
      return NO;
    }
    
    xmpp_conn_set_jid(_conn, ABCString(acnt));
    _account = [acnt copy];
    
    xmpp_conn_set_pass(_conn, ABCString(pswd));
    _password = [pswd copy];
    
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    [map setObject:[NSValue valueWithPointer:_conn] forKey:@"conn"];
    [map setObject:[NSValue valueWithPointer:&_sendQueue] forKey:@"sendQueue"];
    [map setObject:_sendQueueLock forKey:@"sendQueueLock"];
    
    [self performSelector:@selector(connectAndRun:)
                 onThread:[[self class] workingThread]
               withObject:map
            waitUntilDone:NO];
    
    return YES;
  }
  
  return NO;
}

- (void)disconnect
{
  DDLogDebug(@"[engine] Launch disconnect");
  [_sendQueueLock lock];
  while ( _sendQueue ) {
    [_sendQueueLock unlock];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
    [_sendQueueLock lock];
  }
  xmpp_disconnect(_conn);
  [_sendQueueLock unlock];
}

- (void)cleanup
{
  DDLogDebug(@"[engine] Cleanup context");
  xmpp_shutdown();
  
  xmpp_ctx_t *ctx = NULL;
  if ( _conn ) {
    ctx = _conn->ctx;
    xmpp_conn_release(_conn);
    _conn = NULL;
  }
  if ( ctx ) {
    xmpp_ctx_free(ctx);
  }
  
  _account = nil;
  _password = nil;
  
  ab_destroy_queue((ab_rawdata_t **)(&_sendQueue));
  _sendQueueLock = nil;
}


- (ABEngineState)state
{
  if ( _conn ) {
    xmpp_conn_state_t state = _conn->state;
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
  return ( (_conn==NULL) || (_conn->state==XMPP_STATE_DISCONNECTED) );
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
    NSString *iden = [self makeIdentifier:@"vcard_request" suffix:_account];
    
    xmpp_id_handler_add(_conn, ab_vcard_request_handler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanza];
    [iq setNodeName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOString(_conn->bound_jid) forAttribute:@"from"];
    [iq setValue:ABOStringOrLater(jid, _account) forAttribute:@"to"];
    
    ABStanza *vcard = [self makeStanza];
    [vcard setNodeName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    NSData *raw = [iq raw];
    [self sendRaw:[raw bytes] length:[raw length]];
  }
}

- (void)updateVcard:(NSString *)nickname desc:(NSString *)desc
{
//  <iq id='v2'
//      type='set'>
//    <vCard xmlns='vcard-temp'>
//      <NICKNAME>nickname</NICKNAME>
//      <DESC>desc</DESC>
//    </vCard>
//  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"vcard_update" suffix:_account];
    
    xmpp_id_handler_add(_conn, ab_vcard_update_handler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanza];
    [iq setNodeName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"set" forAttribute:@"type"];
    [iq setValue:ABOString(_conn->bound_jid) forAttribute:@"from"];
    
    ABStanza *vcard = [self makeStanza];
    [vcard setNodeName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    ABStanza *nm = [self makeStanza];
    [nm setNodeName:@"NICKNAME"];
    [vcard addChild:nm];
    ABStanza *nmbody = [self makeStanza];
    [nmbody setTextValue:ABOStringOrLater(nickname, @"")];
    [nm addChild:nmbody];
    
    ABStanza *ds = [self makeStanza];
    [ds setNodeName:@"DESC"];
    [vcard addChild:ds];
    ABStanza *dsbody = [self makeStanza];
    [dsbody setTextValue:ABOStringOrLater(desc, @"")];
    [ds addChild:dsbody];
    
    NSData *raw = [iq raw];
    [self sendRaw:[raw bytes] length:[raw length]];
  }
}


- (void)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id='bv1bs71f'
//      type='get'
//      from='juliet@example.com/balcony'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"roster_request" suffix:_account];
    
    xmpp_id_handler_add(_conn, ab_roster_request_handler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanza];
    [iq setNodeName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOString(_conn->bound_jid) forAttribute:@"from"];
    
    ABStanza *query = [self makeStanza];
    [query setNodeName:@"query"];
    [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
    [iq addChild:query];
    
    NSData *raw = [iq raw];
    [self sendRaw:[raw bytes] length:[raw length]];
  }
}


- (ABStanza *)makeStanza
{
  ABStanza *node = nil;
  if ( (_conn) && (_conn->ctx) ) {
    node = [[ABStanza alloc] init];
    node.stanza = xmpp_stanza_new(_conn->ctx);
  }
  return node;
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
    
    char *string = ab_identifier_create(ABCString(domain), ABCString(rand));
    if ( ABCNonempty(string) ) {
      identifier = [[NSString alloc] initWithUTF8String:string];
    }
  }
  return identifier;
}



#pragma mark - Notify methods

- (void)didReceiveRoster:(NSArray *)roster
{
  NSArray *observerAry = [self observers];
  for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
    id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
    [delegate engine:self didReceiveRoster:roster];
  }
}

#pragma mark - Private methods

- (void)connectAndRun:(id)object
{
  xmpp_conn_t *conn = [object[@"conn"] pointerValue];
  ab_rawdata_t **sendQueue = [object[@"sendQueue"] pointerValue];
  NSLock *sendQueueLock = object[@"sendQueueLock"];
  
  int ret = xmpp_connect_client(conn, ABJabberHost, ABJabberPort, ab_connection_handler, NULL);
  
  if ( ret==XMPP_EOK ) {
    
    if ( conn->ctx->loop_status==XMPP_LOOP_NOTSTARTED ) {
      
      conn->ctx->loop_status = XMPP_LOOP_RUNNING;
      
      while ( conn->ctx->loop_status==XMPP_LOOP_RUNNING ) {
        
        // Run
        xmpp_run_once(conn->ctx, 1);
        
        // Send
        [sendQueueLock lock];
        ab_rawdata_t *head = *sendQueue;
        while ( head ) {
          ab_rawdata_t *next = head->next;
          xmpp_send_raw(conn, head->data, head->length);
          xmpp_debug(conn->ctx, "conn", "SENT: %s", head->data);
          ab_destroy_rawdata(head);
          head = next;
        }
        *sendQueue = NULL;
        [sendQueueLock unlock];
      }
      
      xmpp_debug(conn->ctx, "event", "Event loop completed.");
    }
    
  }
  
  [self cleanup];
}


- (void)sendRaw:(const char *)data length:(size_t)length
{
  if ( [self isConnected] ) {
    [_sendQueueLock lock];
    ab_enqueue((ab_rawdata_t **)(&_sendQueue), ab_create_rawdata(data, length));
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
