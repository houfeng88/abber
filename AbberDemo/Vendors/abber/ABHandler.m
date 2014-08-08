//
//  ABHandler.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABHandler.h"

void ABConnectionHandler(xmpp_conn_t * const conn,
                         const xmpp_conn_event_t status,
                         const int error,
                         xmpp_stream_error_t * const stream_error,
                         void * const userdata)
{
  //ABEngine *engine = (__bridge ABEngine *)userdata;
  
  if ( status==XMPP_CONN_CONNECT ) {
    DDLogCDebug(@"[conn] Handler: connected");
  } else if ( status==XMPP_CONN_DISCONNECT ) {
    DDLogCDebug(@"[conn] Handler: disconnected");
  } else if ( status==XMPP_CONN_FAIL ) {
    DDLogCDebug(@"[conn] Handler: failed");
  }
}









