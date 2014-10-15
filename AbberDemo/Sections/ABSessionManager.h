//
//  ABSessionManager.h
//  AbberDemo
//
//  Created by Kevin on 10/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABSessionManager : NSObject {
  NSString *_jid;
  
  NSMutableArray *_sessionAry;
  NSMutableDictionary *_messageAryMap;
}

- (id)initWithJid:(NSString *)jid;

- (void)addSession:(NSString *)session;
- (void)removeSession:(NSString *)session;

- (NSArray *)sessionAry;
- (NSArray *)messageAryForJid:(NSString *)jid;

@end
