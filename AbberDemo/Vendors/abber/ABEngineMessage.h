//
//  ABEngineMessage.h
//  AbberDemo
//
//  Created by Kevin on 9/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (IncomeMessage)

- (void)addMessageHandler;
- (void)removeMessageHandler;

@end

@interface ABEngine (Message)

- (BOOL)sendMessage:(NSString *)msg jid:(NSString *)jid;

@end


@protocol ABEngineMessageDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveMessage:(NSString *)msg jid:(NSString *)jid;

@end
