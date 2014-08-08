//
//  ABEngineRoster.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineRoster.h"

int ABRosterRequestHandler(xmpp_conn_t * const conn,
                           xmpp_stanza_t * const stanza,
                           void * const userdata)
{
  DDLogCDebug(@"Roster request complete");
  return 0;
}

int ABRosterUpdateHandler(xmpp_conn_t * const conn,
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



@implementation ABEngine (Roster)

- (void)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler
{
  //  <iq id='bv1bs71f'
  //      type='get'
  //      from='juliet@example.com/balcony'>
  //    <query xmlns='jabber:iq:roster'/>
  //  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"roster_request" suffix:_account];
    
    xmpp_id_handler_add(_conn, ABRosterRequestHandler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanza];
    [iq setNodeName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
    
    ABStanza *query = [self makeStanza];
    [query setNodeName:@"query"];
    [query setValue:@"jabber:iq:roster" forAttribute:@"xmlns"];
    [iq addChild:query];
    
    [self sendStanza:iq];
  }
}



#pragma mark - Notify methods

- (void)didReceiveRoster:(NSArray *)roster
{
  NSArray *observerAry = [self observers];
  for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
    id<ABEngineDelegate> delegate = [observerAry objectAtIndex:i];
    [delegate engine:self didReceiveRoster:roster];
  }
}

@end