//
//  ABEnginePresence.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

typedef enum {
  ABPresenceTypeUnavailable = 0,
  ABPresenceTypeAvailable   = 1,
  ABPresenceTypeChat        = 2,
  ABPresenceTypeAway        = 3,
  ABPresenceTypeDND         = 4,
  ABPresenceTypeXA          = 5
} ABPresenceType;

@interface ABEngine (IncomePresence)

- (void)addPresenceHandler;
- (void)removePresenceHandler;

- (void)didReceiveFriendRequest:(NSString *)jid;

- (void)didReceiveContactStatus:(NSString *)jid presence:(int)presence;

@end

@interface ABEngine (Presence)

- (BOOL)updatePresence:(int)type;

- (BOOL)subscribeContact:(NSString *)jid;
- (BOOL)subscribedContact:(NSString *)jid;
- (BOOL)unsubscribeContact:(NSString *)jid;
- (BOOL)unsubscribedContact:(NSString *)jid;

- (NSString *)presenceString:(int)presence;

@end


@protocol ABEnginePresenceDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveFriendRequest:(NSString *)jid;

- (void)engine:(ABEngine *)engine didReceiveContactStatus:(NSString *)jid presence:(int)presence;

@end
