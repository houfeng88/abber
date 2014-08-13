//
//  ABEnginePresence.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"
#import "ABCommon.h"

typedef enum {
  ABPresenceTypeAvailable   = 0,
  ABPresenceTypeChat        = 1,
  ABPresenceTypeAway        = 2,
  ABPresenceTypeDND         = 3,
  ABPresenceTypeXA          = 4,
  ABPresenceTypeUnavailable = 5
} ABPresenceType;

@interface ABEngine (Presence)

- (BOOL)updatePresence:(ABPresenceType)type;


- (BOOL)subscribeContact:(NSString *)jid;

- (BOOL)unsubscribeContact:(NSString *)jid;


- (BOOL)acceptContact:(NSString *)jid;

- (BOOL)declineContact:(NSString *)jid;

@end
