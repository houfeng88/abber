//
//  ABEngineVcard.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineVcard.h"

int ABVcardRequestHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"vCard request complete");
  return 0;
}

int ABVcardUpdateHandler(xmpp_conn_t * const conn,
                         xmpp_stanza_t * const stanza,
                         void * const userdata)
{
  DDLogCDebug(@"vCard update complete");
  return 0;
}



@implementation ABEngine (Vcard)

- (void)requestVcard:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler
{
  //  <iq id="32cb7637-8bdc-4a53-afb7-d6f30f2a841d"
  //      type="get">
  //    <vCard xmlns="vcard-temp"/>
  //  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"vcard_request" suffix:_account];
    
    xmpp_id_handler_add(_conn, ABVcardRequestHandler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanza];
    [iq setNodeName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
    [iq setValue:ABOStringOrLater(jid, _account) forAttribute:@"to"];
    
    ABStanza *vcard = [self makeStanza];
    [vcard setNodeName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    [self sendStanza:iq];
  }
}

- (void)updateVcard:(NSString *)nickname desc:(NSString *)desc
{
  //  <iq id='v2'
  //      type='set'>
  //    <vCard xmlns='vcard-temp'>
  //      <NICKNAME>nickname</NICKNAME>
  //      <DESC>desc</DESC>
  //    </vCard>
  //  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [self makeIdentifier:@"vcard_update" suffix:_account];
    
    xmpp_id_handler_add(_conn, ABVcardUpdateHandler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanza];
    [iq setNodeName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"set" forAttribute:@"type"];
    [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
    
    ABStanza *vcard = [self makeStanza];
    [vcard setNodeName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    ABStanza *nm = [self makeStanza];
    [nm setNodeName:@"NICKNAME"];
    [vcard addChild:nm];
    ABStanza *nmbody = [self makeStanza];
    [nmbody setTextValue:ABOStringOrLater(nickname, @"")];
    [nm addChild:nmbody];
    
    ABStanza *ds = [self makeStanza];
    [ds setNodeName:@"DESC"];
    [vcard addChild:ds];
    ABStanza *dsbody = [self makeStanza];
    [dsbody setTextValue:ABOStringOrLater(desc, @"")];
    [ds addChild:dsbody];
    
    [self sendStanza:iq];
  }
}

@end
