//
//  ABCommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABCommon.h"

#pragma mark - Logger

void ABWriteLog(void * const userdata,
                const xmpp_log_level_t level,
                const char * const area,
                const char * const msg)
{
  if ( level==XMPP_LEVEL_DEBUG ) {
    DDLogCDebug(@"[%s] %s", area, msg);
  } else if ( level==XMPP_LEVEL_INFO ) {
    DDLogCInfo (@"[%s] %s", area, msg);
  } else if ( level==XMPP_LEVEL_WARN ) {
    DDLogCWarn (@"[%s] %s", area, msg);
  } else if ( level==XMPP_LEVEL_ERROR ) {
    DDLogCError(@"[%s] %s", area, msg);
  }
}

xmpp_log_t ABDefaultLogger = { &ABWriteLog, NULL };


#pragma mark - Misc

NSString *ABMakeIdentifier(NSString *domain)
{
  NSString *identifier = nil;
  if ( ABOSNonempty(domain) ) {
    identifier = [[NSMutableString alloc] init];
    
    [(NSMutableString *)identifier appendString:domain];
    
    [(NSMutableString *)identifier appendString:@"-"];
    
    [(NSMutableString *)identifier appendString:[[NSUUID UUID] UUIDString]];
  }
  return identifier;
}
