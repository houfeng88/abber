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

#import "ABObject.h"

void ABConnectionHandler(xmpp_conn_t * const conn,
                         const xmpp_conn_event_t status,
                         const int error,
                         xmpp_stream_error_t * const stream_error,
                         void * const userdata)
{
//  NSDictionary *context = CFBridgingRelease(userdata);
//  ABEngine *engine = [context objectForKey:@"Engine"];
//  
//  NSString *string = [context objectForKey:@"String"];
//  
//  NSLog(@"[BBC] userdata: %p", userdata);
//  NSLog(@"[BBC] engine: %p", engine);
//  NSLog(@"[BBC] string: %p %@", string, string);
  
  //ABEngine *engine = CFDictionaryGetValue(userdata, "Engine");
  
  if ( status==XMPP_CONN_CONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: connected");
    
  } else if ( status==XMPP_CONN_DISCONNECT ) {
    
    DDLogCDebug(@"[conn] Handler: disconnected");
    
    xmpp_stop(conn->ctx);
  } else if ( status==XMPP_CONN_FAIL ) {
    
    DDLogCDebug(@"[conn] Handler: failed");
    
    xmpp_stop(conn->ctx);
  }
  
  //CFRelease(userdata);
}



@implementation ABEngine (Connection)

- (void)connectAndRun:(xmpp_conn_t *)connection
{
  int ret = xmpp_connect_client(connection,
                                ABJabberHost,
                                ABJabberPort,
                                ABConnectionHandler,
                                NULL);
  
  if ( ret==XMPP_EOK ) {
    xmpp_run(connection->ctx);
    [self cleanup];
  }
}

//- (void)connectAndRun:(id)object
//{
//  //ABObject *obj = [[ABObject alloc] init];
//  
//  xmpp_conn_t *connection = [[object objectForKey:@"Connection"] pointerValue];
//  ABRaw **sendQueue = [[object objectForKey:@"SendQueue"] pointerValue];
//  NSLock *sendQueueLock = [object objectForKey:@"SendQueueLock"];
//  
//  NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
////  [context setObject:self forKey:@"Engine"];
////  
////  [context setObject:@"ABC" forKey:@"String"];
////  
////  NSLog(@"[ABC] context: %p", context);
////  NSLog(@"[ABC] engine: %p", self);
//  
//  int ret = xmpp_connect_client(connection,
//                                ABJabberHost,
//                                ABJabberPort,
//                                ABConnectionHandler,
//                                CFBridgingRetain(context));
//
//  if ( ret==XMPP_EOK ) {
//    
//    if ( connection->ctx->loop_status==XMPP_LOOP_NOTSTARTED ) {
//      
//      connection->ctx->loop_status = XMPP_LOOP_RUNNING;
//      
//      while ( connection->ctx->loop_status==XMPP_LOOP_RUNNING ) {
//        
//        // Run
//        xmpp_run_once(connection->ctx, 1);
//        
//        // Send
//        [sendQueueLock lock];
//        ABRaw *head = *sendQueue;
//        while ( head ) {
//          ABRaw *next = head->next;
//          xmpp_send_raw(connection, head->data, head->length);
//          xmpp_debug(connection->ctx, "conn", "SENT: %s", head->data);
//          ABRawDestroy(head);
//          head = next;
//        }
//        *sendQueue = NULL;
//        [sendQueueLock unlock];
//      }
//      
//      xmpp_debug(connection->ctx, "event", "Event loop completed.");
//    }
//    
//  }
//  
//  [self cleanup];
//}

@end
