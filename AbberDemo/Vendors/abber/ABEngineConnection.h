//
//  ABEngineConnection.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (Connection)

- (void)connectAndRun;

@end


@protocol ABEngineConnectionDelegate <NSObject>
@optional

- (void)engineDidStartConnecting:(ABEngine *)engine;
- (void)engine:(ABEngine *)engine didReceiveConnectStatus:(BOOL)status;
- (void)engineDidDisconnected:(ABEngine *)engine;

@end
