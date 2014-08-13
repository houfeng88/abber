//
//  ABEnginePresence.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEnginePresence.h"

@implementation ABEngine (Presence)

- (BOOL)updatePresence:(ABPresenceType)type
{
  if ( [self isConnected] ) {
    if ( type==ABPresenceTypeAvailable ) {
      [self sendString:@"<presence />"];
    } else if ( type==ABPresenceTypeChat ) {
      [self sendString:@"<presence><show>chat</show></presence>"];
    } else if ( type==ABPresenceTypeAway ) {
      [self sendString:@"<presence><show>away</show></presence>"];
    } else if ( type==ABPresenceTypeDND ) {
      [self sendString:@"<presence><show>dnd</show></presence>"];
    } else if ( type==ABPresenceTypeXA ) {
      [self sendString:@"<presence><show>xa</show></presence>"];
    } else {
      [self sendString:@"<presence type='unavailable' />"];
    }
    return YES;
  }
  return NO;
}


- (BOOL)subscribeContact:(NSString *)jid
{
  if ( [self isConnected] ) {
    if ( ABOSNonempty(jid) ) {
      
      ABStanza *presence = [self makeStanzaWithName:@"presence"];
      [presence setValue:@"subscribe" forAttribute:@"type"];
      [presence setValue:jid forAttribute:@"to"];
      
      [self sendData:[presence raw]];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)unsubscribeContact:(NSString *)jid
{
  if ( [self isConnected] ) {
    if ( ABOSNonempty(jid) ) {
      // ...
      return YES;
    }
  }
  return NO;
}

@end
