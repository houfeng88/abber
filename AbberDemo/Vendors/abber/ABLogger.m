//
//  ABLogger.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABLogger.h"
#include <strophe/strophe.h>

static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#ifdef DEBUG
//
//#else
//static const int ddLogLevel = LOG_LEVEL_OFF;
//#endif

void ab_default_logger(void * const userdata,
                       const xmpp_log_level_t level,
                       const char * const area,
                       const char * const msg)
{
  xmpp_log_level_t filter_level = * (xmpp_log_level_t*)userdata;
  if (level >= filter_level) {
    if ( level==XMPP_LEVEL_DEBUG ) {
      DDLogDebug(@"%s %s %s", area, "DEBUG", msg);
    } else if ( level==XMPP_LEVEL_INFO ) {
      DDLogInfo(@"%s %s %s", area, "INFO", msg);
    } else if ( level==XMPP_LEVEL_WARN ) {
      DDLogWarn(@"%s %s %s", area, "WARN", msg);
    } else if ( level==XMPP_LEVEL_ERROR ) {
      DDLogError(@"%s %s %s", area, "ERROR", msg);
    }
  }
}
