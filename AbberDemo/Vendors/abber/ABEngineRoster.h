//
//  ABEngineRoster.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABHandlerContext.h"
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

- (void)addRosterPushHandler;
- (void)removeRosterPushHandler;

- (void)rosterOperationTimeout:(ABHandlerContext *)context;

- (BOOL)requestRosterWithCompletion:(ABEngineCompletionHandler)handler;
- (BOOL)addContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)handler;
- (BOOL)updateContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)handler;
- (BOOL)removeContact:(NSString *)jid completion:(ABEngineCompletionHandler)handler;


- (void)didReceiveRosterItem:(NSDictionary *)item;

- (void)didReceiveRoster:(NSArray *)roster error:(NSError *)error;
- (void)didCompleteAddContact:(NSString *)jid error:(NSError *)error;
- (void)didCompleteUpdateContact:(NSString *)jid error:(NSError *)error;
- (void)didCompleteRemoveContact:(NSString *)jid error:(NSError *)error;

@end


@protocol ABEngineRosterDelegate <NSObject>
@optional

// { @"ask":@"__", @"jid":@"__", @"name":@"__", @"subscription":@"__" }

- (void)engine:(ABEngine *)engine didReceiveRosterItem:(NSDictionary *)item;

- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteAddContact:(NSString *)jid error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteUpdateContact:(NSString *)jid error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteRemoveContact:(NSString *)jid error:(NSError *)error;

@end
