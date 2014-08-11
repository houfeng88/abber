//
//  ABEngineRoster.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineRoster.h"

int ABRosterRequestHandler(xmpp_conn_t * const conn,
                           xmpp_stanza_t * const stanza,
                           void * const userdata)
{
  DDLogCDebug(@"Roster request complete");
  
  if ( userdata ) {
    CFDictionaryRef context = userdata;
    
    NSValue *engineValue = CFDictionaryGetValue(context, CFSTR("Engine"));
    ABEngine *engine = [engineValue nonretainedObjectValue];
    
    ABEngineRequestCompletionHandler handler = CFDictionaryGetValue(context, CFSTR("Handler"));
    
    
    NSMutableArray *roster = [[NSMutableArray alloc] init];
    
    if ( stanza ) {
      
      char *type = xmpp_stanza_get_type(stanza);
      if ( strcmp(type, "error")!=0 ) {
        xmpp_stanza_t *query = xmpp_stanza_get_child_by_name(stanza, "query");
        xmpp_stanza_t *item = xmpp_stanza_get_children(query);
        while ( item ) {
          char *jid = xmpp_stanza_get_attribute(stanza, "jid");
          char *name = xmpp_stanza_get_attribute(stanza, "name");
          char *subscription = xmpp_stanza_get_attribute(stanza, "subscription");
          if ( ABCNonempty(jid) && ABCNonempty(name) && ABCNonempty(subscription) ) {
            NSDictionary *map = @{@"jid":ABOString(jid), @"name":ABOString(name), @"subscription":ABOString(subscription)};
            [roster addObject:map];
          }
          item = xmpp_stanza_get_next(item);
        }
        
      }
      
    }
    
    if ( handler ) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        handler(roster, nil);
      });
    } else {
      [engine didReceiveRoster:roster];
    }
    
    
    CFRelease(context);
  }
  
  return 0;
}

int ABRosterUpdateHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"Roster update complete");
  
  return 0;
}



@implementation ABEngine (Roster)

- (BOOL)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler
{
//  <iq id='bv1bs71f'
//      type='get'
//      from='juliet@example.com/balcony'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"roster_request" suffix:[self account]];
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
    [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
    xmpp_id_handler_add(_connection, ABRosterRequestHandler, ABCString(iden), CFBridgingRetain(context));
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
    
    ABStanza *query = [self makeStanzaWithName:@"query"];
    [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
    [iq addChild:query];
    
    [self sendStanza:iq];
    
    return YES;
  }
  return NO;
}


- (BOOL)addContact:(NSString *)jid
              name:(NSString *)name
        completion:(ABEngineRequestCompletionHandler)handler
{
//  <iq from='juliet@example.com/balcony'
//      id='ph1xaz53'
//      type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'>
//        <group>Servants</group>
//      </item>
//    </query>
//  </iq>
  if ( ABONonempty(jid) && ABONonempty(name) ) {
    if ( [self isConnected] ) {
      NSString *iden = [self makeIdentifier:@"roster_add" suffix:[self account]];
      
      NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
      [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
      [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
      xmpp_id_handler_add(_connection, ABRosterUpdateHandler, ABCString(iden), CFBridgingRetain(context));
      
      ABStanza *iq = [self makeStanzaWithName:@"iq"];
      [iq setValue:iden forAttribute:@"id"];
      [iq setValue:@"set" forAttribute:@"type"];
      [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
      
      ABStanza *query = [self makeStanzaWithName:@"query"];
      [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
      [iq addChild:query];
      
      ABStanza *item = [self makeStanzaWithName:@"item"];
      [item setValue:jid forAttribute:@"jid"];
      [item setValue:name forAttribute:@"name"];
      [query addChild:item];
      
      [self sendStanza:iq];
      
      return YES;
    }
  }
  return NO;
}

//- (void)removeContact:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler
//{
//}
//
//- (void)updateContact:(NSString *)jid name:(NSString *)name completion:(ABEngineRequestCompletionHandler)handler
//{
//}



- (void)didReceiveRoster:(NSArray *)roster
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
      [delegate engine:self didReceiveRoster:roster];
    }
  });
}

@end
