//
//  ABEnginePresence.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEnginePresence.h"

@implementation ABEngine (Presence)

- (void)updatePresence:(ABPresenceType)type
{
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
}

@end
