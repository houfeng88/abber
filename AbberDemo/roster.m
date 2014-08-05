//
//  roster.m
//  StropheDemo
//
//  Created by Kevin Wu on 8/4/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "roster.h"
#include <strophe/strophe.h>
#include <strophe/common.h>
#include <abber/internal/logger.h>


int handle_reply(xmpp_conn_t * const conn,
                 xmpp_stanza_t * const stanza,
                 void * const userdata)
{
  xmpp_stanza_t *query, *item;
  char *type, *name;
  
  type = xmpp_stanza_get_type(stanza);
  if (strcmp(type, "error") == 0)
    fprintf(stderr, "ERROR: query failed\n");
  else {
    query = xmpp_stanza_get_child_by_name(stanza, "query");
    printf("Roster:\n");
    for (item = xmpp_stanza_get_children(query); item;
         item = xmpp_stanza_get_next(item))
	    if ((name = xmpp_stanza_get_attribute(item, "name")))
        printf("\t %s (%s) sub=%s\n",
               name,
               xmpp_stanza_get_attribute(item, "jid"),
               xmpp_stanza_get_attribute(item, "subscription"));
	    else
        printf("\t %s sub=%s\n",
               xmpp_stanza_get_attribute(item, "jid"),
               xmpp_stanza_get_attribute(item, "subscription"));
    printf("END OF LIST\n");
  }
  
  /* disconnect */
  xmpp_disconnect(conn);
  
  return 0;
}

void roster_conn_handler(xmpp_conn_t * const conn, const xmpp_conn_event_t status,
                  const int error, xmpp_stream_error_t * const stream_error,
                  void * const userdata)
{
  xmpp_ctx_t *ctx = (xmpp_ctx_t *)userdata;
  xmpp_stanza_t *iq, *query;
  
  xmpp_debug(ctx, "event", "This is an debug.");
  xmpp_info(ctx, "event", "This is an info.");
  xmpp_warn(ctx, "event", "This is an warn.");
  xmpp_error(ctx, "event", "This is an error.");
  
  if (status == XMPP_CONN_CONNECT) {
    fprintf(stderr, "DEBUG: connected\n");
    
    /* create iq stanza for request */
    iq = xmpp_stanza_new(ctx);
    xmpp_stanza_set_name(iq, "iq");
    xmpp_stanza_set_type(iq, "get");
    xmpp_stanza_set_id(iq, "roster1");
    
    query = xmpp_stanza_new(ctx);
    xmpp_stanza_set_name(query, "query");
    xmpp_stanza_set_ns(query, XMPP_NS_ROSTER);
    
    xmpp_stanza_add_child(iq, query);
    
    /* we can release the stanza since it belongs to iq now */
    xmpp_stanza_release(query);
    
    /* set up reply handler */
    xmpp_id_handler_add(conn, handle_reply, "roster1", ctx);
    
    /* send out the stanza */
    xmpp_send(conn, iq);
    
    /* release the stanza */
    xmpp_stanza_release(iq);
  } else {
    fprintf(stderr, "DEBUG: disconnected\n");
    xmpp_stop(ctx);
  }
}

void roster()
{
//  char *jid = "kevin@balee.com";
//  char *pass = "123456";
//  char *host = "192.168.7.215";
  
  char *jid = "tslily@is-a-furry.org";
  char *pass = "Kevi5579";
  char *host = "is-a-furry.org";
  
  
  /* initialize lib */
  xmpp_initialize();
  
  /* create a context */
  //xmpp_log_t *log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG); /* pass NULL instead to silence output */
  xmpp_ctx_t *ctx = xmpp_ctx_new(NULL, &ab_default_logger);
  
  /* create a connection */
  xmpp_conn_t *conn = xmpp_conn_new(ctx);
  
  /* setup authentication information */
  xmpp_conn_set_jid(conn, jid);
  xmpp_conn_set_pass(conn, pass);
  
  /* initiate connection */
  xmpp_connect_client(conn, host, 0, roster_conn_handler, ctx);
  
  /* start the event loop */
  xmpp_run(ctx);
  
  /* release our connection and context */
  xmpp_conn_release(conn);
  xmpp_ctx_free(ctx);
  
  /* shutdown lib */
  xmpp_shutdown();
}
