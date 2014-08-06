//
//  ABClient.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>

@interface ABClient : NSObject<
    TKObserving
> {
  xmpp_ctx_t *_ctx;
  xmpp_conn_t *_conn;
}

+ (void)saveObject:(ABClient *)object;

+ (ABClient *)sharedObject;

- (BOOL)connectWithPassport:(NSString *)pspt password:(NSString *)pswd server:(NSString *)svr port:(NSString *)prt;

- (NSString *)passport;
- (NSString *)password;

@end
