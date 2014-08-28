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
  DDLogCDebug(@"vCard request complete.");
//  NSDictionary *map = CFBridgingRelease(userdata);
//  //ABEngineCompletionHandler handler = [map objectForKey:@"handler"];
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
  DDLogCDebug(@"vCard update complete.");
  return 0;
}



@implementation ABEngine (Vcard)

- (void)requestVcard:(NSString *)jid completion:(ABEngineCompletionHandler)handler
{
//  <iq from='stpeter@jabber.org/roundabout' id='v1' type='get'>
//    <vCard xmlns='vcard-temp'/>
//  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [[NSUUID UUID] UUIDString];
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
    [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
    xmpp_id_handler_add(_connection, ABVcardRequestHandler, TKCString(iden), (void *)CFBridgingRetain(context));
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"get" forAttribute:@"type"];
    [iq setValue:ABOStrOrLater([self boundJid], @"") forAttribute:@"from"];
    [iq setValue:ABOStrOrLater(jid, [self account]) forAttribute:@"to"];
    
    ABStanza *vcard = [self makeStanzaWithName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    //[self sendData:[iq data]];
  }
}

- (void)updateVcardWithNickname:(NSString *)nickname
                         avatar:(NSData *)avatar
                           desc:(NSDictionary *)desc
                     completion:(ABEngineCompletionHandler)handler
{
//  <iq id='v2' type='set'>
//    <vCard xmlns='vcard-temp'>
//      <NICKNAME>nickname</NICKNAME>
//      <PHOTO>
//        <TYPE>image/png</TYPE>
//        <BINVAL>Base64-encoded-avatar-file-here!</BINVAL>
//      </PHOTO>
//      <DESC>desc</DESC>
//    </vCard>
//  </iq>
  
  if ( [self isConnected] ) {
    NSString *iden = [[NSUUID UUID] UUIDString];
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    [context setObject:[NSValue valueWithNonretainedObject:self] forKey:@"Engine"];
    [context setObject:[handler copy] forKeyIfNotNil:@"Handler"];
    xmpp_id_handler_add(_connection, ABVcardUpdateHandler, TKCString(iden), (void *)CFBridgingRetain(context));
    
    ABStanza *iq = [self makeStanzaWithName:@"iq"];
    [iq setValue:iden forAttribute:@"id"];
    [iq setValue:@"set" forAttribute:@"type"];
    
    ABStanza *vcard = [self makeStanzaWithName:@"vCard"];
    [vcard setValue:@"vcard-temp" forAttribute:@"xmlns"];
    [iq addChild:vcard];
    
    if ( ABOSNonempty(nickname) ) {
      ABStanza *nm = [self makeStanzaWithName:@"NICKNAME"];
      ABStanza *nmbody = [self makeStanzaWithName:nil];
      [nmbody setTextValue:nickname];
      [nm addChild:nmbody];
      [vcard addChild:nm];
    }
    
//    if ( [avatar length]>0 ) {
//    }
//    
//    if ( [desc count]>0 ) {
//      NSData *data = [NSJSONSerialization dataWithJSONObject:desc
//                                                     options:0
//                                                       error:NULL];
//      NSString *encoded = [data base64EncodedStringWithOptions:<#(NSDataBase64EncodingOptions)#>];
//    }
//    
//    ABStanza *ds = [self makeStanzaWithName:@"DESC"];
//    [vcard addChild:ds];
//    ABStanza *dsbody = [self makeStanzaWithName:nil];
//    [dsbody setTextValue:ABOStrOrLater(desc, @"")];
//    [ds addChild:dsbody];
//    
//    [self sendData:[iq raw]];
  }
}

@end
