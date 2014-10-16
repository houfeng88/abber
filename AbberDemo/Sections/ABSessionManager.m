//
//  ABSessionManager.m
//  AbberDemo
//
//  Created by Kevin on 10/15/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABSessionManager.h"

@implementation ABSessionManager

- (id)initWithJid:(NSString *)jid
{
  self = [super init];
  if (self) {
    _jid = jid;
    
    
    _sessionAry = [[NSMutableArray alloc] init];
    
    NSString *path = [TKPathForDocumentResource(jid) stringByAppendingPathComponent:@"sessions.db"];
    NSArray *sessionAry = [[NSArray alloc] initWithContentsOfFile:path];
    for ( NSUInteger i=0; i<[sessionAry count]; ++i ) {
      NSString *session = [sessionAry objectAtIndex:i];
      if ( TKSNonempty(session) ) {
        [_sessionAry addObject:session];
      }
    }
    
    
    _messageAryMap = [[NSMutableDictionary alloc] init];
    
    for ( NSString *session in _sessionAry ) {
      NSMutableArray *messageAry = [[NSMutableArray alloc] init];
      [_messageAryMap setObject:messageAry forKey:session];
    }
  }
  return self;
}


- (void)addSession:(NSString *)session
{
  if ( TKSNonempty(session) ) {
    if ( ![_messageAryMap objectForKey:session] ) {
      [_sessionAry addObject:session];
      
      NSMutableArray *messageAry = [[NSMutableArray alloc] init];
      [_messageAryMap setObject:messageAry forKey:session];
      
      
      NSString *path = [TKPathForDocumentResource(_jid) stringByAppendingPathComponent:@"sessions.db"];
      [_sessionAry writeToFile:path atomically:YES];
    }
  }
}

- (void)removeSession:(NSString *)session
{
  if ( TKSNonempty(session) ) {
    [_sessionAry removeObject:session];
    [_messageAryMap removeObjectForKey:session];
    
    NSString *path = [TKPathForDocumentResource(_jid) stringByAppendingPathComponent:@"sessions.db"];
    [_sessionAry writeToFile:path atomically:YES];
  }
}


- (NSArray *)sessionAry
{
  return _sessionAry;
}

- (NSArray *)messageAryForJid:(NSString *)jid
{
  return [_messageAryMap objectForKey:jid];
}

@end
