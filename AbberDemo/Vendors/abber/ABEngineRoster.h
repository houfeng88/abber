//
//  ABEngineRoster.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (RosterIncome)

- (void)addRosterPushHandler;
- (void)removeRosterPushHandler;

@end

@interface ABEngine (Roster)

- (BOOL)requestRosterWithCompletion:(ABEngineCompletionHandler)completion;
- (BOOL)addContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion;
- (BOOL)updateContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion;
- (BOOL)removeContact:(NSString *)jid completion:(ABEngineCompletionHandler)completion;

@end


@protocol ABEngineRosterDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveRosterUpdate:(ABContact *)contact;

- (void)engine:(ABEngine *)engine didReceiveRoster:(NSArray *)roster error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteAddContact:(NSString *)jid error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteUpdateContact:(NSString *)jid error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteRemoveContact:(NSString *)jid error:(NSError *)error;

@end
