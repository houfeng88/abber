//
//  abhandler.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "abhandler.h"

void ab_connection_handler(xmpp_conn_t * const conn,
                           const xmpp_conn_event_t status,
                           const int error,
                           xmpp_stream_error_t * const stream_error,
                           void * const userdata)
{
  //ABEngine *engine = (__bridge ABEngine *)userdata;
  
  if ( status==XMPP_CONN_CONNECT ) {
    DDLogCDebug(@"[conn] Handler: connected");
  } else if ( status==XMPP_CONN_DISCONNECT ) {
    DDLogCDebug(@"[conn] Handler: disconnected");
  } else if ( status==XMPP_CONN_FAIL ) {
    DDLogCDebug(@"[conn] Handler: failed");
  }
}




int ab_vcard_request_handler(xmpp_conn_t * const conn,
                             xmpp_stanza_t * const stanza,
                             void * const userdata)
{
  DDLogCDebug(@"vCard request complete");
  return 0;
}

int ab_vcard_update_handler(xmpp_conn_t * const conn,
                            xmpp_stanza_t * const stanza,
                            void * const userdata)
{
  DDLogCDebug(@"vCard update complete");
  return 0;
}



int ab_roster_request_handler(xmpp_conn_t * const conn,
                              xmpp_stanza_t * const stanza,
                              void * const userdata)
{
  DDLogCDebug(@"Roster request complete");
  return 0;
}

int ab_roster_update_handler(xmpp_conn_t * const conn,
                             xmpp_stanza_t * const stanza,
                             void * const userdata)
{
  DDLogCDebug(@"Roster update complete");
//  xmpp_stanza_t *query, *item;
//  char *type, *name;
//  
//  type = xmpp_stanza_get_type(stanza);
//  if (strcmp(type, "error") == 0)
//    fprintf(stderr, "ERROR: query failed\n");
//  else {
//    query = xmpp_stanza_get_child_by_name(stanza, "query");
//    printf("Roster:\n");
//    for (item = xmpp_stanza_get_children(query); item;
//         item = xmpp_stanza_get_next(item))
//	    if ((name = xmpp_stanza_get_attribute(item, "name")))
//        printf("\t %s (%s) sub=%s\n",
//               name,
//               xmpp_stanza_get_attribute(item, "jid"),
//               xmpp_stanza_get_attribute(item, "subscription"));
//	    else
//        printf("\t %s sub=%s\n",
//               xmpp_stanza_get_attribute(item, "jid"),
//               xmpp_stanza_get_attribute(item, "subscription"));
//    printf("END OF LIST\n");
//  }
  return 0;
}


