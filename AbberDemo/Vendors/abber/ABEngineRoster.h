//
//  ABEngineRoster.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

typedef enum {
  ABSubscriptionTypeNone    = 0,  // 0000
  ABSubscriptionTypeNoneOut = 1,  // 0001
  ABSubscriptionTypeTo      = 2,  // 0010
  ABSubscriptionTypeToIn    = 3,  // 0011
  ABSubscriptionTypeFrom    = 4,  // 0100
  ABSubscriptionTypeFromOut = 5,  // 0101
  ABSubscriptionTypeBoth    = 6   // 0110
} ABSubscriptionType;


@interface ABEngine (IncomeRoster)

- (void)addRosterPushHandler;
- (void)removeRosterPushHandler;

- (void)didReceiveRosterUpdate:(NSDictionary *)item;

@end

@interface ABEngine (Roster)

- (BOOL)requestRosterWithCompletion:(ABEngineCompletionHandler)completion;
- (BOOL)addContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion;
- (BOOL)updateContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion;
- (BOOL)removeContact:(NSString *)jid completion:(ABEngineCompletionHandler)completion;

- (NSString *)subscriptionString:(int)subscription;

- (void)didReceiveRoster:(NSArray *)roster error:(NSError *)error;
- (void)didCompleteAddContact:(NSString *)jid error:(NSError *)error;
- (void)didCompleteUpdateContact:(NSString *)jid error:(NSError *)error;
- (void)didCompleteRemoveContact:(NSString *)jid error:(NSError *)error;

@end


@protocol ABEngineRosterDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveRosterUpdate:(NSDictionary *)item;

- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteAddContact:(NSString *)jid error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteUpdateContact:(NSString *)jid error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteRemoveContact:(NSString *)jid error:(NSError *)error;

@end
