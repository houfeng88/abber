//
//  ABEngineRoster.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"
#import "ABCommon.h"

typedef enum {
  ABSubscriptionTypeNone    = 0,
  ABSubscriptionTypeNoneOut = 1,
  ABSubscriptionTypeTo      = 2,
  ABSubscriptionTypeToIn    = 3,
  ABSubscriptionTypeFrom    = 4,
  ABSubscriptionTypeFromOut = 5,
  ABSubscriptionTypeBoth    = 6
} ABSubscriptionType;


@interface ABEngine (Roster)

- (void)prepareForRosterPush;


- (BOOL)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler;

- (BOOL)addContact:(NSString *)jid
              name:(NSString *)name
        completion:(ABEngineRequestCompletionHandler)handler;

- (BOOL)updateContact:(NSString *)jid
                 name:(NSString *)name
           completion:(ABEngineRequestCompletionHandler)handler;

- (BOOL)removeContact:(NSString *)jid
           completion:(ABEngineRequestCompletionHandler)handler;


- (void)didReceiveRoster:(NSArray *)roster;

- (void)didReceiveRosterItem:(NSDictionary *)item;

- (void)didChangeRoster:(NSString *)jid;

@end
