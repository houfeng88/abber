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

@end

@interface ABEngine (Message)

- (void)sendMessage:(NSString *)message jid:(NSString *)jid;

@end


@protocol ABEngineMessageDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveMessage:(NSString *)message jid:(NSString *)jid;
- (void)engine:(ABEngine *)engine didSendMessage:(NSString *)message jid:(NSString *)jid;

@end
