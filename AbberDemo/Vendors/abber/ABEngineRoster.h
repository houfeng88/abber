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

- (void)prepareForRosterPush;


- (BOOL)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler;

- (BOOL)addContact:(NSString *)jid
              name:(NSString *)name
        completion:(ABEngineRequestCompletionHandler)handler;

- (BOOL)removeContact:(NSString *)jid
           completion:(ABEngineRequestCompletionHandler)handler;


- (void)didReceiveRoster:(NSArray *)roster;

@end
