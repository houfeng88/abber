//
//  ABEnginePresence.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/12/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

#define ABPresenceUnavailable @"unavailable"
#define ABPresenceAvailable   @"available"
#define ABPresenceChat        @"chat"
#define ABPresenceAway        @"away"
#define ABPresenceDND         @"dnd"
#define ABPresenceXA          @"xa"

@interface ABEngine (PresenceIncome)

- (void)addPresenceHandler;
- (void)removePresenceHandler;

@end

@interface ABEngine (Presence)

- (BOOL)updatePresence:(NSString *)presence;

- (BOOL)subscribeContact:(NSString *)jid;
- (BOOL)subscribedContact:(NSString *)jid;
- (BOOL)unsubscribeContact:(NSString *)jid;
- (BOOL)unsubscribedContact:(NSString *)jid;

@end


@protocol ABEnginePresenceDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveFriendRequest:(NSString *)jid;

- (void)engine:(ABEngine *)engine didReceivePresenceUpdate:(NSString *)jid;

@end
