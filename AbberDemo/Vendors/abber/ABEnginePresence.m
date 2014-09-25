//
//  ABEnginePresence.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEnginePresence.h"

#import "ABEngineStorage.h"

@interface ABEngine (PresenceIncomeNotify)

- (void)didReceiveFriendRequest:(NSString *)jid;

- (void)didReceiveStatus:(NSString *)status contact:(NSString *)jid;

@end

@implementation ABEngine (PresenceIncomeNotify)

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


- (void)didReceiveStatus:(NSString *)status contact:(NSString *)jid
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEnginePresenceDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveStatus:contact:)] ) {
        [delegate engine:self didReceiveStatus:status contact:jid];
      }
    }
  });
}

@end

int ABPresenceHandler(xmpp_conn_t * const conn,
                      xmpp_stanza_t * const stanza,
                      void * const userdata)
{
  DDLogCDebug(@"[presence] Presence received.");
  
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  NSString *type = ABStanzaGetAttribute(stanza, @"type");
  NSString *jid = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));
  
  if ( TKSNonempty(jid) ) {
    if ( [@"error" isEqualToString:type] ) {
      
    } else if ( [@"probe" isEqualToString:type] ) {
      
    } else if ( [@"subscribe" isEqualToString:type] ) {
      ABContact *contact = [engine contactByJid:jid];
      if ( ([@"to" isEqualToString:contact.subscription]) && (!TKSNonempty(contact.ask)) ) {
        [engine subscribedContact:jid];
      } else {
        [engine didReceiveFriendRequest:jid];
      }
    } else if ( [@"subscribed" isEqualToString:type] ) {
      
    } else if ( [@"unavailable" isEqualToString:type] ) {
      ABContact *contact = [engine contactByJid:jid];
      contact.status = ABPresenceUnavailable;
      [engine didReceiveStatus:ABPresenceUnavailable contact:jid];
    } else if ( [@"unsubscribe" isEqualToString:type] ) {
      
    } else if ( [@"unsubscribed" isEqualToString:type] ) {
      
    } else {
      NSString *show = ABStanzaGetText(ABStanzaChildByName(stanza, @"show"));
      if ( [@"chat" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceChat;
        [engine didReceiveStatus:ABPresenceChat contact:jid];
      } else if ( [@"away" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceAway;
        [engine didReceiveStatus:ABPresenceAway contact:jid];
      } else if ( [@"dnd" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceDND;
        [engine didReceiveStatus:ABPresenceDND contact:jid];
      } else if ( [@"xa" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceXA;
        [engine didReceiveStatus:ABPresenceXA contact:jid];
      } else {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceAvailable;
        [engine didReceiveStatus:ABPresenceAvailable contact:jid];
      }
    }
  }
  
  return 1;
}

@implementation ABEngine (PresenceIncome)

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

- (BOOL)updatePresence:(NSString *)status
{
  if ( [self isConnected] ) {
    if ( [ABPresenceAvailable isEqualToString:status] ) {
      [self sendString:@"<presence/>"];
    } else if ( [ABPresenceChat isEqualToString:status] ) {
      [self sendString:@"<presence><show>chat</show></presence>"];
    } else if ( [ABPresenceAway isEqualToString:status] ) {
      [self sendString:@"<presence><show>away</show></presence>"];
    } else if ( [ABPresenceDND isEqualToString:status] ) {
      [self sendString:@"<presence><show>dnd</show></presence>"];
    } else if ( [ABPresenceXA isEqualToString:status] ) {
      [self sendString:@"<presence><show>xa</show></presence>"];
    } else {
      [self sendString:@"<presence type=\"unavailable\"/>"];
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

- (BOOL)subscribedContact:(NSString *)jid
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

- (BOOL)unsubscribedContact:(NSString *)jid
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

@end
