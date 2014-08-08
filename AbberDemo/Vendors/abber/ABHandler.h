//
//  ABHandler.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>
#include <strophe/common.h>

/* Connection */

void ABConnectionHandler(xmpp_conn_t * const conn,
                         const xmpp_conn_event_t status,
                         const int error,
                         xmpp_stream_error_t * const stream_error,
                         void * const userdata);


/* Vcard */

int ABVcardRequestHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata);
int ABVcardUpdateHandler(xmpp_conn_t * const conn,
                         xmpp_stanza_t * const stanza,
                         void * const userdata);


/* Roster */

int ABRosterRequestHandler(xmpp_conn_t * const conn,
                           xmpp_stanza_t * const stanza,
                           void * const userdata);
int ABRosterUpdateHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata);
