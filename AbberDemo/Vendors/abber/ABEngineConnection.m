//
//  ABEngineConnection.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineConnection.h"
#import "ABRaw.h"
#import "ABConfig.h"

void ABConnectionHandler(xmpp_conn_t * const conn,
                         const xmpp_conn_event_t status,
                         const int error,
                         xmpp_stream_error_t * const stream_error,
                         void * const userdata)
{
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  if ( status==XMPP_CONN_CONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: connected");
    
  } else if ( status==XMPP_CONN_DISCONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: disconnected");
    [engine stopLoop];
    
  } else if ( status==XMPP_CONN_FAIL ) {
    
    DDLogCDebug(@"[conn] Handler: failed");
    [engine stopLoop];
    
  }
}



@implementation ABEngine (Connection)

- (void)connectAndRun:(id)object
{
  xmpp_conn_t *conn = [object[@"conn"] pointerValue];
  ABRaw **sendQueue = [object[@"sendQueue"] pointerValue];
  NSLock *sendQueueLock = object[@"sendQueueLock"];
  
  int ret = xmpp_connect_client(conn, ABJabberHost, ABJabberPort, ABConnectionHandler, (__bridge void *)self);
  
  if ( ret==XMPP_EOK ) {
    
    if ( conn->ctx->loop_status==XMPP_LOOP_NOTSTARTED ) {
      
      conn->ctx->loop_status = XMPP_LOOP_RUNNING;
      
      while ( conn->ctx->loop_status==XMPP_LOOP_RUNNING ) {
        
        // Run
        xmpp_run_once(conn->ctx, 1);
        
        // Send
        [sendQueueLock lock];
        ABRaw *head = *sendQueue;
        while ( head ) {
          ABRaw *next = head->next;
          xmpp_send_raw(conn, head->data, head->length);
          xmpp_debug(conn->ctx, "conn", "SENT: %s", head->data);
          ABRawDestroy(head);
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

@end
