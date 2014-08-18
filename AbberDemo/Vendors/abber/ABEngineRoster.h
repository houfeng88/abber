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
  ABSubscriptionTypeNone    = 0,  // 0000
  ABSubscriptionTypeNoneOut = 1,  // 0001
  ABSubscriptionTypeTo      = 2,  // 0010
  ABSubscriptionTypeToIn    = 3,  // 0011
  ABSubscriptionTypeFrom    = 4,  // 0100
  ABSubscriptionTypeFromOut = 5,  // 0101
  ABSubscriptionTypeBoth    = 6   // 0110
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


- (void)didReceiveRosterItem:(NSDictionary *)item;

- (void)didReceiveRoster:(NSArray *)roster error:(NSError *)error;

- (void)didChangeContact:(NSString *)jid error:(NSError *)error;

@end
