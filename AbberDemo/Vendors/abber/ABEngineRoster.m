//
//  ABEngineRoster.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineRoster.h"

int ABRosterPushHandler(xmpp_conn_t * const conn,
                        xmpp_stanza_t * const stanza,
                        void * const userdata)
{
  DDLogCDebug(@"[roster] Roster push received.");
  
  xmpp_stanza_t *iq = xmpp_stanza_new(conn->ctx);
  xmpp_stanza_set_name(iq, "iq");
  xmpp_stanza_set_attribute(iq, "id", xmpp_stanza_get_attribute(stanza, "id"));
  xmpp_stanza_set_attribute(iq, "type", "result");
  xmpp_send(conn, iq);
  xmpp_stanza_release(iq);
  
  
  if ( userdata ) {
    ABEngine *engine = (__bridge ABEngine *)userdata;
    
    xmpp_stanza_t *query = xmpp_stanza_get_child_by_name(stanza, "query");
    if ( query ) {
      xmpp_stanza_t *item = xmpp_stanza_get_child_by_name(query, "item");
      if ( item ) {
        char *ask = xmpp_stanza_get_attribute(item, "ask");
        char *jid = xmpp_stanza_get_attribute(item, "jid");
        char *name = xmpp_stanza_get_attribute(item, "name");
        char *subscription = xmpp_stanza_get_attribute(item, "subscription");
        
        if ( ABCSNonempty(jid) && ABCSNonempty(subscription) ) {
          NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
          if ( ABCSNonempty(ask) ) {
            [map setObject:ABOString(ask) forKey:@"ask"];
          }
          [map setObject:ABOString(jid) forKey:@"jid"];
          if ( ABCSNonempty(name) ) {
            [map setObject:ABOString(name) forKey:@"name"];
          }
          [map setObject:ABOString(subscription) forKey:@"subscription"];
          [engine didReceiveRosterItem:map];
        }
      }
    }
    
  }
  
  return 1;
}


int ABRosterRequestHandler(xmpp_conn_t * const conn,
                           xmpp_stanza_t * const stanza,
                           void * const userdata)
{
  DDLogCDebug(@"[roster] Roster request complete.");
  
  if ( userdata ) {
    ABHandlerContext *context = (__bridge ABHandlerContext *)userdata;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [NSObject cancelPreviousPerformRequestsWithTarget:context.engine
                                               selector:@selector(rosterOperationTimeout:)
                                                 object:context];
    });
    
    
    NSMutableArray *roster = nil;
    NSError *error = nil;
    
    char *type = xmpp_stanza_get_attribute(stanza, "type");
    if ( strcmp(type, "error")==0 ) {
      
      NSDictionary *userInfo = nil;
      char *name = xmpp_stanza_get_error_name(stanza);
      if ( ABCSNonempty(name) ) {
        userInfo = @{ @"ABErrorDescriptionKey": ABOString(name) };
      }
      error = [NSError errorWithDomain:@"abber.org" code:1 userInfo:userInfo];
      
    } else {
      
      roster = [[NSMutableArray alloc] init];
      
      xmpp_stanza_t *query = xmpp_stanza_get_child_by_name(stanza, "query");
      if ( query ) {
        xmpp_stanza_t *item = xmpp_stanza_get_children(query);
        while ( item ) {
          char *jid = xmpp_stanza_get_attribute(item, "jid");
          
          char *memoname = xmpp_stanza_get_attribute(item, "name");
          
          ABSubscriptionType relation = ABSubscriptionTypeNone;
          char *ask = xmpp_stanza_get_attribute(item, "ask");
          char *subscription = xmpp_stanza_get_attribute(item, "subscription");
          if ( strcmp(subscription, "none")==0 ) {
            relation = ((!ABCSNonempty(ask)) ? ABSubscriptionTypeNone : ABSubscriptionTypeNoneOut);
          } else if ( strcmp(subscription, "to")==0 ) {
            relation = ((!ABCSNonempty(ask)) ? ABSubscriptionTypeTo : ABSubscriptionTypeToIn);
          } else if ( strcmp(subscription, "from")==0 ) {
            relation = ((!ABCSNonempty(ask)) ? ABSubscriptionTypeFrom : ABSubscriptionTypeFromOut);
          } else if ( strcmp(subscription, "both")==0 ) {
            relation = ABSubscriptionTypeBoth;
          }
          
          
          if ( ABCSNonempty(jid) ) {
            NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
            
            [map setObject:ABOString(jid) forKey:@"jid"];
            
            if ( ABCSNonempty(memoname) ) {
              [map setObject:ABOString(memoname) forKey:@"memoname"];
            }
            
            [map setObject:@(relation) forKey:@"relation"];
            
            [roster addObject:map];
          }
          item = xmpp_stanza_get_next(item);
        }
        
      }
      
    }
    
    [context.engine didReceiveRoster:roster error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(roster, error);
      });
    }
    
    
    CFRelease((__bridge CFTypeRef)context);
  }
  
  return 0;
}

int ABRosterAddHandler(xmpp_conn_t * const conn,
                       xmpp_stanza_t * const stanza,
                       void * const userdata)
{
  DDLogCDebug(@"[roster] Roster add complete.");
  
  if ( userdata ) {
    ABHandlerContext *context = (__bridge ABHandlerContext *)userdata;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [NSObject cancelPreviousPerformRequestsWithTarget:context.engine
                                               selector:@selector(rosterOperationTimeout:)
                                                 object:context];
    });
    
    
    NSString *jid = nil;
    NSError *error = nil;
    
    char *to = xmpp_stanza_get_attribute(stanza, "to");
    char *bareTo = xmpp_jid_bare(conn->ctx, to);
    if ( ABCSNonempty(bareTo) ) {
      jid = ABOString(bareTo);
      xmpp_free(conn->ctx, bareTo);
    }
    
    char *type = xmpp_stanza_get_attribute(stanza, "type");
    if ( strcmp(type, "error")==0 ) {
      
      NSDictionary *userInfo = nil;
      char *name = xmpp_stanza_get_error_name(stanza);
      if ( ABCSNonempty(name) ) {
        userInfo = @{ @"ABErrorDescriptionKey": ABOString(name) };
      }
      error = [NSError errorWithDomain:@"abber.org" code:1 userInfo:userInfo];
      
    } else {
      
      // ...
      
    }
    
    [context.engine didCompleteAddContact:jid error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(jid, error);
      });
    }
    
    
    CFRelease((__bridge CFTypeRef)context);
  }
  
  return 0;
}

int ABRosterUpdateHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"[roster] Roster update complete.");
  
  if ( userdata ) {
    ABHandlerContext *context = (__bridge ABHandlerContext *)userdata;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [NSObject cancelPreviousPerformRequestsWithTarget:context.engine
                                               selector:@selector(rosterOperationTimeout:)
                                                 object:context];
    });
    
    
    NSString *jid = nil;
    NSError *error = nil;
    
    char *to = xmpp_stanza_get_attribute(stanza, "to");
    char *bareTo = xmpp_jid_bare(conn->ctx, to);
    if ( ABCSNonempty(bareTo) ) {
      jid = ABOString(bareTo);
      xmpp_free(conn->ctx, bareTo);
    }
    
    char *type = xmpp_stanza_get_attribute(stanza, "type");
    if ( strcmp(type, "error")==0 ) {
      
      NSDictionary *userInfo = nil;
      char *name = xmpp_stanza_get_error_name(stanza);
      if ( ABCSNonempty(name) ) {
        userInfo = @{ @"ABErrorDescriptionKey": ABOString(name) };
      }
      error = [NSError errorWithDomain:@"abber.org" code:1 userInfo:userInfo];
      
    } else {
      
      // ...
      
    }
    
    [context.engine didCompleteUpdateContact:jid error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(jid, error);
      });
    }
    
    
    CFRelease((__bridge CFTypeRef)context);
  }
  
  return 0;
}

int ABRosterRemoveHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"[roster] Roster remove complete.");
  
  if ( userdata ) {
    ABHandlerContext *context = (__bridge ABHandlerContext *)userdata;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [NSObject cancelPreviousPerformRequestsWithTarget:context.engine
                                               selector:@selector(rosterOperationTimeout:)
                                                 object:context];
    });
    
    
    NSString *jid = nil;
    NSError *error = nil;
    
    char *to = xmpp_stanza_get_attribute(stanza, "to");
    char *bareTo = xmpp_jid_bare(conn->ctx, to);
    if ( ABCSNonempty(bareTo) ) {
      jid = ABOString(bareTo);
      xmpp_free(conn->ctx, bareTo);
    }
    
    char *type = xmpp_stanza_get_attribute(stanza, "type");
    if ( strcmp(type, "error")==0 ) {
      
      NSDictionary *userInfo = nil;
      char *name = xmpp_stanza_get_error_name(stanza);
      if ( ABCSNonempty(name) ) {
        userInfo = @{ @"ABErrorDescriptionKey": ABOString(name) };
      }
      error = [NSError errorWithDomain:@"abber.org" code:1 userInfo:userInfo];
      
    } else {
      
      // ...
      
    }
    
    [context.engine didCompleteRemoveContact:jid error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(jid, error);
      });
    }
    
    
    CFRelease((__bridge CFTypeRef)context);
  }
  
  return 0;
}



@implementation ABEngine (Roster)

- (void)addRosterPushHandler
{
  xmpp_handler_add(_connection, ABRosterPushHandler, "jabber:iq:roster", "iq", "set", (__bridge void *)self);
}

- (void)removeRosterPushHandler
{
  xmpp_handler_delete(_connection, ABRosterPushHandler);
}


- (void)rosterOperationTimeout:(ABHandlerContext *)context
{
  DDLogDebug(@"[roster] Roster operation time out");
  
  xmpp_id_handler_delete(_connection, context.handler, ABCString(context.identifier));
  
  NSError *error = [NSError errorWithDomain:@"abber.org" code:1 userInfo:@{@"ABErrorDescriptionKey": @"time out"}];
  
  if ( [context.identifier hasPrefix:@"ROSTER-REQUEST"] ) {
    [self didReceiveRoster:nil error:error];
    if ( context.completion ) {
      context.completion(nil, error);
    }
  } else if ( [context.identifier hasPrefix:@"ROSTER-ADD"] ) {
    [self didCompleteAddContact:context.info error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(context.jid, error);
      });
    }
  } else if ( [context.identifier hasPrefix:@"ROSTER-UPDATE"] ) {
    [self didCompleteUpdateContact:context.info error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(context.jid, error);
      });
    }
  } else if ( [context.identifier hasPrefix:@"ROSTER-REMOVE"] ) {
    [self didCompleteRemoveContact:context.info error:error];
    if ( context.completion ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        context.completion(context.jid, error);
      });
    }
  }
  
  CFRelease((__bridge CFTypeRef)context);
}


- (BOOL)requestRosterWithCompletion:(ABEngineCompletionHandler)completion
{
//  <iq id='bv1bs71f' type='get'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  if ( [self isConnected] ) {
    NSString *identifier = ABMakeIdentifier(@"ROSTER-REQUEST");
    
    ABHandlerContext *context = [[ABHandlerContext alloc] init];
    context.engine = self;
    context.completion = completion;
    context.identifier = identifier;
    context.handler = ABRosterRequestHandler;
    
    xmpp_id_handler_add(_connection, ABRosterRequestHandler, ABCString(identifier), (void *)CFBridgingRetain(context));
    [self performSelector:@selector(rosterOperationTimeout:) withObject:context afterDelay:10.0];
    
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:identifier forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    
    ABStanza *query = [self makeStanzaWithName:@"query"];
    [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
    [iq addChild:query];
    
    [self sendData:[iq rawData]];
    
    return YES;
  }
  return NO;
}

- (BOOL)addContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion
{
//  <iq id='ph1xaz53' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'/>
//    </query>
//  </iq>
  if ( ABOSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *identifier = ABMakeIdentifier(@"ROSTER-ADD");
      
      ABHandlerContext *context = [[ABHandlerContext alloc] init];
      context.engine = self;
      context.jid = jid;
      context.completion = completion;
      context.identifier = identifier;
      context.handler = ABRosterAddHandler;
      
      xmpp_id_handler_add(_connection, ABRosterAddHandler, ABCString(identifier), (void *)CFBridgingRetain(context));
      [self performSelector:@selector(rosterOperationTimeout:) withObject:context afterDelay:10.0];
      
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:identifier forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      if ( ABOSNonempty(name) ) {
        [item setValue:name forAttribute:@"name"];
      }
      [query addChild:item];
      
      [self sendData:[iq rawData]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)updateContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion
{
//  <iq id='ph1xaz53' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'/>
//    </query>
//  </iq>
  if ( ABOSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *identifier = ABMakeIdentifier(@"ROSTER-UPDATE");
      
      ABHandlerContext *context = [[ABHandlerContext alloc] init];
      context.engine = self;
      context.jid = jid;
      context.completion = completion;
      context.identifier = identifier;
      context.handler = ABRosterUpdateHandler;
      
      xmpp_id_handler_add(_connection, ABRosterUpdateHandler, ABCString(identifier), (void *)CFBridgingRetain(context));
      [self performSelector:@selector(rosterOperationTimeout:) withObject:context afterDelay:10.0];
      
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:identifier forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      [item setValue:ABOStringOrLater(name, @"") forAttribute:@"name"];
      [query addChild:item];
      
      [self sendData:[iq rawData]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)removeContact:(NSString *)jid completion:(ABEngineCompletionHandler)completion
{
//  <iq id='hm4hs97y' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' subscription='remove'/>
//    </query>
//  </iq>
  if ( ABOSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *identifier = ABMakeIdentifier(@"ROSTER-REMOVE");
      
      ABHandlerContext *context = [[ABHandlerContext alloc] init];
      context.engine = self;
      context.jid = jid;
      context.completion = completion;
      context.identifier = identifier;
      context.handler = ABRosterRemoveHandler;
      
      xmpp_id_handler_add(_connection, ABRosterRemoveHandler, ABCString(identifier), (void *)CFBridgingRetain(context));
      [self performSelector:@selector(rosterOperationTimeout:) withObject:context afterDelay:10.0];
      
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:identifier forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      [item setValue:@"remove" forAttribute:@"subscription"];
      [query addChild:item];
      
      [self sendData:[iq rawData]];
      
      return YES;
    }
  }
  return NO;
}



- (void)didReceiveRosterItem:(NSDictionary *)item
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveRosterItem:)] ) {
        [delegate engine:self didReceiveRosterItem:item];
      }
    }
  });
}


- (void)didReceiveRoster:(NSArray *)roster error:(NSError *)error
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveRoster:error:)] ) {
        [delegate engine:self didReceiveRoster:roster error:error];
      }
    }
  });
}

- (void)didCompleteAddContact:(NSString *)jid error:(NSError *)error
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteAddContact:error:)] ) {
        [delegate engine:self didCompleteAddContact:jid error:error];
      }
    }
  });
}

- (void)didCompleteUpdateContact:(NSString *)jid error:(NSError *)error
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteUpdateContact:error:)] ) {
        [delegate engine:self didCompleteUpdateContact:jid error:error];
      }
    }
  });
}

- (void)didCompleteRemoveContact:(NSString *)jid error:(NSError *)error
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteRemoveContact:error:)] ) {
        [delegate engine:self didCompleteRemoveContact:jid error:error];
      }
    }
  });
}

@end
