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
  DDLogCDebug(@"[roster] Push received.");
  
  if ( userdata ) {
    ABEngine *engine = (__bridge ABEngine *)userdata;
    
    
    xmpp_stanza_t *iq = xmpp_stanza_new(conn->ctx);
    xmpp_stanza_set_name(iq, "iq");
    xmpp_stanza_set_attribute(iq, "id", xmpp_stanza_get_attribute(stanza, "id"));
    xmpp_stanza_set_attribute(iq, "type", "result");
    xmpp_send(conn, iq);
    xmpp_stanza_release(iq);
    
    xmpp_stanza_t *query = xmpp_stanza_get_child_by_name(stanza, "query");
    xmpp_stanza_t *item = xmpp_stanza_get_children(query);
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
  
  return 1;
}

int ABRosterRequestHandler(xmpp_conn_t * const conn,
                           xmpp_stanza_t * const stanza,
                           void * const userdata)
{
  DDLogCDebug(@"[roster] Request complete.");
  
  if ( userdata ) {
    CFDictionaryRef context = userdata;
    ABEngine *engine = [(__bridge NSValue *)CFDictionaryGetValue(context, CFSTR("Engine")) nonretainedObjectValue];
    ABEngineRequestCompletionHandler handler = CFDictionaryGetValue(context, CFSTR("Handler"));
    
    
    NSMutableArray *roster = [[NSMutableArray alloc] init];
    NSError *error = nil;
    
    char *type = xmpp_stanza_get_attribute(stanza, "type");
    if ( strcmp(type, "error")==0 ) {
      
      NSDictionary *userInfo = nil;
      char *name = xmpp_stanza_get_error_name(stanza);
      if ( ABCSNonempty(name) ) {
        userInfo = @{ @"ABErrorDescriptionKey": ABOString(name) };
      }
      error = [NSError errorWithDomain:@"abber.org" code:0 userInfo:userInfo];
      
    } else {
      
      xmpp_stanza_t *query = xmpp_stanza_get_child_by_name(stanza, "query");
      xmpp_stanza_t *item = xmpp_stanza_get_children(query);
      while ( item ) {
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
          [roster addObject:map];
        }
        item = xmpp_stanza_get_next(item);
      }
      
    }
    
    [engine didReceiveRoster:roster error:error];
    if ( handler ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        handler(roster, error);
      });
    }
    
    
    CFRelease(context);
  }
  
  return 0;
}

int ABRosterChangeHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"[roster] Change complete.");
  
  if ( userdata ) {
    CFDictionaryRef context = userdata;
    ABEngine *engine = [(__bridge NSValue *)CFDictionaryGetValue(context, CFSTR("Engine")) nonretainedObjectValue];
    ABEngineRequestCompletionHandler handler = CFDictionaryGetValue(context, CFSTR("Handler"));
    
    
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
      error = [NSError errorWithDomain:@"abber.org" code:0 userInfo:userInfo];
      
    } else {
      
      // ...
      
    }
    
    [engine didChangeContact:jid error:error];
    if ( handler ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        handler(jid, error);
      });
    }
    
    
    CFRelease(context);
  }
  
  return 0;
}



@implementation ABEngine (Roster)

- (void)prepareForRosterPush
{
  xmpp_handler_add(_connection,
                   ABRosterPushHandler,
                   "jabber:iq:roster",
                   "iq",
                   "set",
                   (__bridge void *)self);
}


- (BOOL)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id='bv1bs71f' type='get'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"roster_request" suffix:[self account]];
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
    [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
    xmpp_id_handler_add(_connection, ABRosterRequestHandler, ABCString(iden), (void *)CFBridgingRetain(context));
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    
    ABStanza *query = [self makeStanzaWithName:@"query"];
    [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
    [iq addChild:query];
    
    [self sendData:[iq raw]];
    
    return YES;
  }
  return NO;
}

- (BOOL)addContact:(NSString *)jid
              name:(NSString *)name
        completion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id='ph1xaz53' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'/>
//    </query>
//  </iq>
  if ( ABOSNonempty(jid) && ABOSNonempty(name) ) {
    if ( [self isConnected] ) {
      NSString *iden = [self makeIdentifier:@"roster_add" suffix:[self account]];
      
      NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
      [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
      [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
      xmpp_id_handler_add(_connection, ABRosterChangeHandler, ABCString(iden), (void *)CFBridgingRetain(context));
      
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:iden forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      [item setValue:name forAttribute:@"name"];
      [query addChild:item];
      
      [self sendData:[iq raw]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)updateContact:(NSString *)jid
                 name:(NSString *)name
           completion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id='ph1xaz53' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'/>
//    </query>
//  </iq>
  if ( ABOSNonempty(jid) && ABOSNonempty(name) ) {
    if ( [self isConnected] ) {
      NSString *iden = [self makeIdentifier:@"roster_update" suffix:[self account]];
      
      NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
      [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
      [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
      xmpp_id_handler_add(_connection, ABRosterChangeHandler, ABCString(iden), (void *)CFBridgingRetain(context));
      
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:iden forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      [item setValue:name forAttribute:@"name"];
      [query addChild:item];
      
      [self sendData:[iq raw]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)removeContact:(NSString *)jid
           completion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id='hm4hs97y' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' subscription='remove'/>
//    </query>
//  </iq>
  if ( ABOSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *iden = [self makeIdentifier:@"roster_remove" suffix:[self account]];
      
      NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
      [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
      [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
      xmpp_id_handler_add(_connection, ABRosterChangeHandler, ABCString(iden), (void *)CFBridgingRetain(context));
      
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:iden forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      [item setValue:@"remove" forAttribute:@"subscription"];
      [query addChild:item];
      
      [self sendData:[iq raw]];
      
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
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
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
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveRoster:error:)] ) {
        [delegate engine:self didReceiveRoster:roster error:error];
      }
    }
  });
}

- (void)didChangeContact:(NSString *)jid error:(NSError *)error
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didChangeContact:error:)] ) {
        [delegate engine:self didChangeContact:jid error:error];
      }
    }
  });
}

@end
