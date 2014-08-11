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
//  NSDictionary *map = CFBridgingRelease(userdata);
//  //ABEngineRequestCompletionHandler handler = [map objectForKey:@"handler"];
//  //ABEngine *engine = [map objectForKey:@"engine"];
//  ABObject *obj = [map objectForKey:@"object"];
  
  //ABObject *obj = CFBridgingRelease(userdata);
  //NSLog(@"%@", obj);
  
  CFRelease(userdata);
  
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
    NSString *iden = [self makeIdentifier:@"vcard_request" suffix:[self account]];
    
//    ABObject *obj = [[ABObject alloc] init];
    
//    void *pointer = CFBridgingRetain(obj);
//    xmpp_id_handler_add(_conn, ABVcardRequestHandler, ABCString(iden), pointer);
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
    [iq setValue:ABOStringOrLater(jid, [self account]) forAttribute:@"to"];
    
    ABStanza *vcard = [self makeStanzaWithName:@"vCard"];
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
    NSString *iden = [self makeIdentifier:@"vcard_update" suffix:[self account]];
    
    xmpp_id_handler_add(_connection, ABVcardUpdateHandler, ABCString(iden), NULL);
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"set" forAttribute:@"type"];
    [iq setValue:ABOStringOrLater([self boundJid], @"") forAttribute:@"from"];
    
    ABStanza *vcard = [self makeStanzaWithName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    ABStanza *nm = [self makeStanzaWithName:@"NICKNAME"];
    [vcard addChild:nm];
    ABStanza *nmbody = [self makeStanzaWithName:nil];
    [nmbody setTextValue:ABOStringOrLater(nickname, @"")];
    [nm addChild:nmbody];
    
    ABStanza *ds = [self makeStanzaWithName:@"DESC"];
    [vcard addChild:ds];
    ABStanza *dsbody = [self makeStanzaWithName:nil];
    [dsbody setTextValue:ABOStringOrLater(desc, @"")];
    [ds addChild:dsbody];
    
    [self sendStanza:iq];
  }
}

@end
