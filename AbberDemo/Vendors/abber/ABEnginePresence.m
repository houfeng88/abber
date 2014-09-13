//
//  ABEnginePresence.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEnginePresence.h"

int ABPresenceHandler(xmpp_conn_t * const conn,
                      xmpp_stanza_t * const stanza,
                      void * const userdata)
{
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  //<presence to="tkcara@blah.im" type="unavailable" from="tkbill@blah.im"/>
  
  //<presence from="tkcara@blah.im/teemo"/>
  //<presence type="subscribe" from="tkcara@blah.im"/>
  
  NSLog(@"==============================");
  NSLog(@"%@", ABStanzaToString(stanza));
  NSLog(@"==============================");
  
  NSString *type = ABStanzaGetAttribute(stanza, @"type");
  if ( [@"subscribe" isEqualToString:type] ) {
    NSString *jid = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));
    [engine didReceiveFriendRequest:jid];
  }
  
  return 1;
}


@implementation ABEngine (IncomePresence)

- (void)addPresenceHandler
{
  xmpp_handler_add(_connection, ABPresenceHandler, NULL, "presence", NULL, (__bridge void *)self);
}

- (void)removePresenceHandler
{
  xmpp_handler_delete(_connection, ABPresenceHandler);
}

@end



@implementation ABEngine (Presence)

- (BOOL)updatePresence:(ABPresenceType)type
{
  if ( [self isConnected] ) {
    if ( type==ABPresenceTypeAvailable ) {
      [self sendString:@"<presence/>"];
    } else if ( type==ABPresenceTypeChat ) {
      [self sendString:@"<presence><show>chat</show></presence>"];
    } else if ( type==ABPresenceTypeAway ) {
      [self sendString:@"<presence><show>away</show></presence>"];
    } else if ( type==ABPresenceTypeDND ) {
      [self sendString:@"<presence><show>dnd</show></presence>"];
    } else if ( type==ABPresenceTypeXA ) {
      [self sendString:@"<presence><show>xa</show></presence>"];
    } else {
      [self sendString:@"<presence type='unavailable'/>"];
    }
    return YES;
  }
  return NO;
}


- (BOOL)subscribeContact:(NSString *)jid
{
//  <presence to='juliet@example.com' type='subscribe'/>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) ) {
      
      xmpp_stanza_t *presence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(presence, @"to", jid);
      ABStanzaSetAttribute(presence, @"type", @"subscribe");
      
      [self sendData:ABStanzaToData(presence)];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)unsubscribeContact:(NSString *)jid
{
//  <presence to='juliet@example.com' type='unsubscribe'/>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) ) {
      
      xmpp_stanza_t *presence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(presence, @"to", jid);
      ABStanzaSetAttribute(presence, @"type", @"unsubscribe");
      
      [self sendData:ABStanzaToData(presence)];
      
      return YES;
    }
  }
  return NO;
}


- (BOOL)acceptContact:(NSString *)jid
{
//  <presence to='romeo@example.com' type='subscribed'/>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) ) {
      
      xmpp_stanza_t *presence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(presence, @"to", jid);
      ABStanzaSetAttribute(presence, @"type", @"subscribed");
      
      [self sendData:ABStanzaToData(presence)];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)declineContact:(NSString *)jid
{
//  <presence to='romeo@example.net' type='unsubscribed'/>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) ) {
      
      xmpp_stanza_t *presence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(presence, @"to", jid);
      ABStanzaSetAttribute(presence, @"type", @"unsubscribed");
      
      [self sendData:ABStanzaToData(presence)];
      
      return YES;
    }
  }
  return NO;
}


- (void)didReceiveFriendRequest:(NSString *)jid
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEnginePresenceDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveFriendRequest:)] ) {
        [delegate engine:self didReceiveFriendRequest:jid];
      }
    }
  });
}

@end
