//
//  ABEngineConnection.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineConnection.h"
#import "ABConfig.h"

void ABConnectionHandler(xmpp_conn_t * const conn,
                         const xmpp_conn_event_t status,
                         const int error,
                         xmpp_stream_error_t * const stream_error,
                         void * const userdata)
{
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  if ( status==XMPP_CONN_CONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: connected.");
    [engine didReceiveConnectStatus:YES];
    
  } else if ( status==XMPP_CONN_FAIL ) {
    
    DDLogCDebug(@"[conn] Handler: failed.");
    xmpp_stop(conn->ctx);
    [engine didReceiveConnectStatus:NO];
    
  } else if ( status==XMPP_CONN_DISCONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: disconnected.");
    xmpp_stop(conn->ctx);
    [engine didDisconnected];
    
  }
}



@implementation ABEngine (Connection)

- (void)connectAndRun:(xmpp_conn_t *)connection
{
  [self didStartConnecting];
  
  int ret = xmpp_connect_client(connection,
                                ABJabberHost,
                                ABJabberPort,
                                ABConnectionHandler,
                                (__bridge void *)self);
  
  if ( ret==XMPP_EOK ) {
    xmpp_run(connection->ctx);
    [self cleanup];
  } else {
    [self didReceiveConnectStatus:NO];
  }
}


- (void)didStartConnecting
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
      [delegate engineDidStartConnecting:self];
    }
  });
}

- (void)didReceiveConnectStatus:(BOOL)status
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
      [delegate engine:self didReceiveConnectStatus:status];
    }
  });
}

- (void)didDisconnected
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
      [delegate engineDidDisconnected:self];
    }
  });
}

@end
