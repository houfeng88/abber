//
//  ABEngineMessage.h
//  AbberDemo
//
//  Created by Kevin on 9/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (MessageIncome)

- (void)addMessageHandler;
- (void)removeMessageHandler;

@end

@interface ABEngine (Message)

- (BOOL)sendMessage:(ABMessage *)message;

@end


@protocol ABEngineMessageDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveMessage:(ABMessage *)message;

@end
