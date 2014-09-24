//
//  ABEnginePresence.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEnginePresence.h"

#import "ABEngineStorage.h"

#import "ABEngineRoster.h"

@interface ABEngine (IncomePresenceNotify)

- (void)didReceiveFriendRequest:(NSString *)jid;

- (void)didReceivePresence:(NSInteger)presence contact:(NSString *)jid;

@end

@implementation ABEngine (IncomePresenceNotify)

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


- (void)didReceivePresence:(NSInteger)presence contact:(NSString *)jid
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEnginePresenceDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceivePresence:contact:)] ) {
        [delegate engine:self didReceivePresence:presence contact:jid];
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
      if ( (contact) && (contact.relation==ABSubscriptionTypeTo) ) {
        [engine subscribedContact:jid];
      } else {
        [engine didReceiveFriendRequest:jid];
      }
    } else if ( [@"subscribed" isEqualToString:type] ) {
      
    } else if ( [@"unavailable" isEqualToString:type] ) {
      ABContact *contact = [engine contactByJid:jid];
      contact.status = ABPresenceTypeUnavailable;
      [engine didReceivePresence:ABPresenceTypeUnavailable contact:jid];
    } else if ( [@"unsubscribe" isEqualToString:type] ) {
      
    } else if ( [@"unsubscribed" isEqualToString:type] ) {
      
    } else {
      NSString *show = ABStanzaGetText(ABStanzaChildByName(stanza, @"show"));
      if ( [@"chat" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceTypeChat;
        [engine didReceivePresence:ABPresenceTypeChat contact:jid];
      } else if ( [@"away" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceTypeAway;
        [engine didReceivePresence:ABPresenceTypeAway contact:jid];
      } else if ( [@"dnd" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceTypeDND;
        [engine didReceivePresence:ABPresenceTypeDND contact:jid];
      } else if ( [@"xa" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceTypeXA;
        [engine didReceivePresence:ABPresenceTypeXA contact:jid];
      } else {
        ABContact *contact = [engine contactByJid:jid];
        contact.status = ABPresenceTypeAvailable;
        [engine didReceivePresence:ABPresenceTypeAvailable contact:jid];
      }
    }
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

- (BOOL)updatePresence:(int)type
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


- (NSString *)statusString:(int)presence
{
  if ( presence==ABPresenceTypeUnavailable ) {
    return NSLocalizedString(@"Unavailable", @"");
  } else if ( presence==ABPresenceTypeAvailable ) {
    return NSLocalizedString(@"Available", @"");
  } else if ( presence==ABPresenceTypeChat ) {
    return NSLocalizedString(@"Chat", @"");
  } else if ( presence==ABPresenceTypeAway ) {
    return NSLocalizedString(@"Away", @"");
  } else if ( presence==ABPresenceTypeDND ) {
    return NSLocalizedString(@"DND", @"");
  } else if ( presence==ABPresenceTypeXA ) {
    return NSLocalizedString(@"XA", @"");
  }
  return NSLocalizedString(@"Unavailable", @"");
}

@end
