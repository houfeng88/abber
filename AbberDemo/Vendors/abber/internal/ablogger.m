//
//  ablogger.m
//  AbberDemo
//
//  Created by Kevin on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "ablogger.h"

void ab_write_log(void * const userdata,
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

xmpp_log_t ab_default_logger = { &ab_write_log, NULL };