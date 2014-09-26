//
//  ABEngineConnection.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineConnection.h"

@interface ABEngine (ConnectionNotify)

- (void)didStartConnecting;
- (void)didReceiveConnectStatus:(BOOL)status;
- (void)didDisconnected;

@end

@implementation ABEngine (ConnectionNotify)

- (void)didStartConnecting
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineConnectionDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engineDidStartConnecting:)] ) {
        [delegate engineDidStartConnecting:self];
      }
    }
  });
}

- (void)didReceiveConnectStatus:(BOOL)status
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineConnectionDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveConnectStatus:)] ) {
        [delegate engine:self didReceiveConnectStatus:status];
      }
    }
  });
}

- (void)didDisconnected
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineConnectionDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engineDidDisconnected:)] ) {
        [delegate engineDidDisconnected:self];
      }
    }
  });
}

@end

void ABConnectionHandler(xmpp_conn_t * const conn,
                         const xmpp_conn_event_t status,
                         const int error,
                         xmpp_stream_error_t * const stream_error,
                         void * const userdata)
{
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  if ( status==XMPP_CONN_CONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: connected.");
    NSString *root = TKPathForDocumentResource([engine bareJid]);
    TKCreateDirectory(root);
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

- (void)connectAndRun
{
  [self didStartConnecting];
  
  int ret = xmpp_connect_client(_connection,
                                [ABJabberHost UTF8String],
                                [ABJabberPort intValue],
                                ABConnectionHandler,
                                (__bridge void *)self);
  
  if ( ret==XMPP_EOK ) {
    xmpp_run(_connection->ctx);
    [self cleanup];
  } else {
    [self didReceiveConnectStatus:NO];
  }
}

@end
