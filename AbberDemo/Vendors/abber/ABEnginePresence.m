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

- (void)didReceivePresenceUpdate:(NSString *)jid;

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


- (void)didReceivePresenceUpdate:(NSString *)jid
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEnginePresenceDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceivePresenceUpdate:)] ) {
        [delegate engine:self didReceivePresenceUpdate:jid];
      }
    }
  });
}

@end

int ABPresenceHandler(xmpp_conn_t * const conn,
                      xmpp_stanza_t * const stanza,
                      void * const userdata)
{
  DDLogCDebug(@"[presence] Presence received");
  
  ABEngine *engine = (__bridge ABEngine *)userdata;

  NSString *from = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));
  if ( TKSNonempty(from) ) {

    NSString *type = ABStanzaGetAttribute(stanza, @"type");
    if ( [@"error" isEqualToString:type] ) {
      
    } else if ( [@"probe" isEqualToString:type] ) {
      
    } else if ( [@"subscribe" isEqualToString:type] ) {
      ABContact *contact = [engine contactByJid:from];
      if ( ([@"to" isEqualToString:contact.subscription]) && (!TKSNonempty(contact.ask)) ) {
        [engine subscribedContact:from];
      } else {
        [engine didReceiveFriendRequest:from];
      }
    } else if ( [@"subscribed" isEqualToString:type] ) {
      
    } else if ( [@"unavailable" isEqualToString:type] ) {
      ABContact *contact = [engine contactByJid:from];
      contact.status = ABPresenceUnavailable;
      [engine didReceivePresenceUpdate:from];
    } else if ( [@"unsubscribe" isEqualToString:type] ) {
      
    } else if ( [@"unsubscribed" isEqualToString:type] ) {
      
    } else {
      xmpp_stanza_t *cshow = ABStanzaChildByName(stanza, @"show");
      NSString *show = ABStanzaGetText(cshow);
      if ( [@"chat" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:from];
        contact.status = ABPresenceChat;
        [engine didReceivePresenceUpdate:from];
      } else if ( [@"away" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:from];
        contact.status = ABPresenceAway;
        [engine didReceivePresenceUpdate:from];
      } else if ( [@"dnd" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:from];
        contact.status = ABPresenceDND;
        [engine didReceivePresenceUpdate:from];
      } else if ( [@"xa" isEqualToString:show] ) {
        ABContact *contact = [engine contactByJid:from];
        contact.status = ABPresenceXA;
        [engine didReceivePresenceUpdate:from];
      } else {
        ABContact *contact = [engine contactByJid:from];
        contact.status = ABPresenceAvailable;
        [engine didReceivePresenceUpdate:from];
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

- (BOOL)updatePresence:(NSString *)presence
{
  if ( [self isConnected] ) {
    if ( [ABPresenceAvailable isEqualToString:presence] ) {
      [self sendString:@"<presence/>"];
      _user.status = ABPresenceAvailable;
    } else if ( [ABPresenceChat isEqualToString:presence] ) {
      [self sendString:@"<presence><show>chat</show></presence>"];
      _user.status = ABPresenceChat;
    } else if ( [ABPresenceAway isEqualToString:presence] ) {
      [self sendString:@"<presence><show>away</show></presence>"];
      _user.status = ABPresenceAway;
    } else if ( [ABPresenceDND isEqualToString:presence] ) {
      [self sendString:@"<presence><show>dnd</show></presence>"];
      _user.status = ABPresenceDND;
    } else if ( [ABPresenceXA isEqualToString:presence] ) {
      [self sendString:@"<presence><show>xa</show></presence>"];
      _user.status = ABPresenceXA;
    } else {
      [self sendString:@"<presence type=\"unavailable\"/>"];
      _user.status = ABPresenceUnavailable;
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
      
      xmpp_stanza_t *cpresence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(cpresence, @"to", jid);
      ABStanzaSetAttribute(cpresence, @"type", @"subscribe");
      
      [self sendData:ABStanzaToData(cpresence)];
      ABStanzaRelease(cpresence);
      
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
      
      xmpp_stanza_t *cpresence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(cpresence, @"to", jid);
      ABStanzaSetAttribute(cpresence, @"type", @"subscribed");
      
      [self sendData:ABStanzaToData(cpresence)];
      ABStanzaRelease(cpresence);
      
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
      
      xmpp_stanza_t *cpresence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(cpresence, @"to", jid);
      ABStanzaSetAttribute(cpresence, @"type", @"unsubscribe");
      
      [self sendData:ABStanzaToData(cpresence)];
      ABStanzaRelease(cpresence);
      
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
      
      xmpp_stanza_t *cpresence = ABStanzaCreate(_connection->ctx, @"presence", nil);
      ABStanzaSetAttribute(cpresence, @"to", jid);
      ABStanzaSetAttribute(cpresence, @"type", @"unsubscribed");
      
      [self sendData:ABStanzaToData(cpresence)];
      ABStanzaRelease(cpresence);
      
      return YES;
    }
  }
  return NO;
}

@end
