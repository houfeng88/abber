//
//  abhandler.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include <strophe/strophe.h>
#include <strophe/common.h>

#ifndef AB_HANDLER_H
#define AB_HANDLER_H

/* Connection */

void ab_connection_handler(xmpp_conn_t * const conn,
                           const xmpp_conn_event_t status,
                           const int error,
                           xmpp_stream_error_t * const stream_error,
                           void * const userdata);


/* Vcard */

int ab_vcard_request_handler(xmpp_conn_t * const conn,
                             xmpp_stanza_t * const stanza,
                             void * const userdata);
int ab_vcard_update_handler(xmpp_conn_t * const conn,
                            xmpp_stanza_t * const stanza,
                            void * const userdata);


/* Roster */

int ab_roster_request_handler(xmpp_conn_t * const conn,
                              xmpp_stanza_t * const stanza,
                              void * const userdata);
int ab_roster_update_handler(xmpp_conn_t * const conn,
                             xmpp_stanza_t * const stanza,
                             void * const userdata);

#endif /* AB_HANDLER_H */