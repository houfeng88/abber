//
//  basic.m
//  StropheDemo
//
//  Created by Kevin Wu on 8/4/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "basic.h"
#import "strophe/strophe.h"

void basic_conn_handler(xmpp_conn_t * const conn, const xmpp_conn_event_t status,
                  const int error, xmpp_stream_error_t * const stream_error,
                  void * const userdata)
{
  xmpp_ctx_t *ctx = (xmpp_ctx_t *)userdata;
  
  if (status == XMPP_CONN_CONNECT) {
    fprintf(stderr, "DEBUG: connected\n");
    xmpp_disconnect(conn);
  }
  else {
    fprintf(stderr, "DEBUG: disconnected\n");
    xmpp_stop(ctx);
  }
}


void basic()
{
  char *jid = "kevin@balee.com";
  char *pass = "123456";
  char *host = "192.168.7.215";
  
  /* init library */
  xmpp_initialize();
  
  /* create a context */
  xmpp_log_t *log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG); /* pass NULL instead to silence output */
  xmpp_ctx_t *ctx = xmpp_ctx_new(NULL, log);
  
  /* create a connection */
  xmpp_conn_t *conn = xmpp_conn_new(ctx);
  
  /* setup authentication information */
  xmpp_conn_set_jid(conn, jid);
  xmpp_conn_set_pass(conn, pass);
  
  /* initiate connection */
  xmpp_connect_client(conn, host, 0, basic_conn_handler, ctx);
  
  /* enter the event loop -
   our connect handler will trigger an exit */
  xmpp_run(ctx);
  
  /* release our connection and context */
  xmpp_conn_release(conn);
  xmpp_ctx_free(ctx);
  
  /* final shutdown of the library */
  xmpp_shutdown();
}
