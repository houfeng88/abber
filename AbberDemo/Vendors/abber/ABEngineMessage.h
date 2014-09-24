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

- (BOOL)sendText:(NSString *)text jid:(NSString *)jid;
- (BOOL)sendAudio:(NSData *)audio jid:(NSString *)jid;
- (BOOL)sendImage:(NSData *)image jid:(NSString *)jid;
- (BOOL)sendNudge:(NSString *)jid;

@end


@protocol ABEngineMessageDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveMessage:(id)msg type:(NSString *)type jid:(NSString *)jid;

@end
