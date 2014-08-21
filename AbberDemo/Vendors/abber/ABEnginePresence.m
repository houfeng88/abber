//
//  ABEnginePresence.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEnginePresence.h"

@implementation ABEngine (Presence)

- (void)prepareForPresenceUpdate
{
}


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
    if ( ABOSNonempty(jid) ) {
      
      ABStanza *presence = [self makeStanzaWithName:@"presence"];
      [presence setValue:jid forAttribute:@"to"];
      [presence setValue:@"subscribe" forAttribute:@"type"];
      
      [self sendData:[presence rawData]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)unsubscribeContact:(NSString *)jid
{
//  <presence to='juliet@example.com' type='unsubscribe'/>
  if ( [self isConnected] ) {
    if ( ABOSNonempty(jid) ) {
      
      ABStanza *presence = [self makeStanzaWithName:@"presence"];
      [presence setValue:jid forAttribute:@"to"];
      [presence setValue:@"unsubscribe" forAttribute:@"type"];
      
      [self sendData:[presence rawData]];
      
      return YES;
    }
  }
  return NO;
}


- (BOOL)acceptContact:(NSString *)jid
{
//  <presence to='romeo@example.com' type='subscribed'/>
  if ( [self isConnected] ) {
    if ( ABOSNonempty(jid) ) {
      
      ABStanza *presence = [self makeStanzaWithName:@"presence"];
      [presence setValue:jid forAttribute:@"to"];
      [presence setValue:@"subscribed" forAttribute:@"type"];
      
      [self sendData:[presence rawData]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)declineContact:(NSString *)jid
{
//  <presence to='romeo@example.net' type='unsubscribed'/>
  if ( [self isConnected] ) {
    if ( ABOSNonempty(jid) ) {
      
      ABStanza *presence = [self makeStanzaWithName:@"presence"];
      [presence setValue:jid forAttribute:@"to"];
      [presence setValue:@"unsubscribed" forAttribute:@"type"];
      
      [self sendData:[presence rawData]];
      
      return YES;
    }
  }
  return NO;
}

@end
