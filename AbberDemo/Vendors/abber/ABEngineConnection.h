//
//  ABEngineConnection.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"
#import "ABCommon.h"

@interface ABEngine (Connection)

- (void)connectAndRun:(xmpp_conn_t *)connection;

- (void)didStartConnecting;
- (void)didReceiveConnectStatus:(BOOL)status;
- (void)didDisconnected;

@end
