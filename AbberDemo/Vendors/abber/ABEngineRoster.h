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

@interface ABEngine (Roster)

- (BOOL)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler;

- (BOOL)addContact:(NSString *)jid
              name:(NSString *)name
        completion:(ABEngineRequestCompletionHandler)handler;

//- (void)removeContact:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler;
//- (void)updateContact:(NSString *)jid memo:(NSString *)memo completion:(ABEngineRequestCompletionHandler)handler;


- (void)didReceiveRoster:(NSArray *)roster;

@end
