//
//  ABEngineVcard.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineVcard.h"

@interface ABEngine (VcardNotify)

- (void)didReceiveVcard:(NSDictionary *)vcard error:(NSError *)error completion:(ABEngineCompletionHandler)completion;
- (void)didCompleteUpdateVcard:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion;

@end

@implementation ABEngine (VcardNotify)

- (void)didReceiveVcard:(NSDictionary *)vcard error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineVcardDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveVcard:error:)] ) {
        [delegate engine:self didReceiveVcard:vcard error:error];
      }
    }
    if ( completion ) {
      completion(vcard, error);
    }
  });
}

- (void)didCompleteUpdateVcard:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineVcardDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteUpdateVcard:error:)] ) {
        [delegate engine:self didCompleteUpdateVcard:jid error:error];
      }
    }
    if ( completion ) {
      completion(jid, error);
    }
  });
}

@end

int ABVcardRequestHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"[vcard] Vcard request complete.");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");
  
  //  <iq id="CAC41DEC-2931-4012-BC03-5ECC8CC10E35" to="tkcara@blah.im/abber" type="result">
  //    <vCard xmlns="vcard-temp">
  //      <NICKNAME>CARA</NICKNAME>
  //      <DESC>kj</DESC>
  //    </vCard>
  //  </iq>
  
  xmpp_stanza_t *vcard = ABStanzaChildByName(stanza, @"vCard");
  
  
  NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
  
  NSString *jid = ABStanzaGetAttribute(stanza, @"from");
  [map setObject:TKStrOrLater(jid, [engine bareJid]) forKey:@"jid"];
  
  xmpp_stanza_t *nm = ABStanzaChildByName(vcard, @"NICKNAME");
  [map setObject:ABStanzaGetText(nm) forKeyIfNotNil:@"nickname"];
  
  xmpp_stanza_t *ds = ABStanzaChildByName(vcard, @"DESC");
  [map setObject:ABStanzaGetText(ds) forKeyIfNotNil:@"desc"];
  
  
  ABHandlexDestroy(userdata);
  return 0;
}

int ABVcardUpdateHandler(xmpp_conn_t * const conn,
                         xmpp_stanza_t * const stanza,
                         void * const userdata)
{
  DDLogCDebug(@"[vcard] Vcard update complete.");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");
  
  //<iq id="87F9FC6E-A492-4D4E-A3A7-DF3BD04A7736" to="tkcara@blah.im/abber" type="result"/>
  
  ABHandlexDestroy(userdata);
  return 0;
}

@implementation ABEngine (Vcard)

- (void)requestVcard:(NSString *)jid completion:(ABEngineCompletionHandler)completion
{
//  <iq from='stpeter@jabber.org/roundabout' id='v1' type='get'>
//    <vCard xmlns='vcard-temp'/>
//  </iq>
  if ( [self isConnected] ) {
    NSString *identifier = [[NSUUID UUID] UUIDString];
    
    void *contextRef = ABHandlexCreate();
    ABHandlexSetNonretainedObject(contextRef, @"engine", self);
    if ( completion ) ABHandlexSetObject(contextRef, @"completion", [completion copy]);
    
    xmpp_id_handler_add(_connection, ABVcardRequestHandler, TKCString(identifier), contextRef);
    
    xmpp_stanza_t *iq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(iq, @"id", identifier);
    ABStanzaSetAttribute(iq, @"type", @"get");
    ABStanzaSetAttribute(iq, @"from", [self boundJid]);
    ABStanzaSetAttribute(iq, @"to", TKStrOrLater(jid, nil));
    
    xmpp_stanza_t *vcard = ABStanzaCreate(_connection->ctx, @"vCard", nil);
    ABStanzaSetAttribute(vcard, @"xmlns", @"vcard-temp");
    ABStanzaAddChild(iq, vcard);
    
    [self sendData:ABStanzaToData(iq)];
  }
}

- (void)updateVcardWithNickname:(NSString *)nickname desc:(NSString *)desc completion:(ABEngineCompletionHandler)completion
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
    NSString *identifier = [[NSUUID UUID] UUIDString];
    
    void *contextRef = ABHandlexCreate();
    ABHandlexSetNonretainedObject(contextRef, @"engine", self);
    if ( completion ) ABHandlexSetObject(contextRef, @"completion", [completion copy]);
    
    xmpp_id_handler_add(_connection, ABVcardUpdateHandler, TKCString(identifier), contextRef);
    
    xmpp_stanza_t *iq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(iq, @"id", identifier);
    ABStanzaSetAttribute(iq, @"type", @"set");
    
    xmpp_stanza_t *vcard = ABStanzaCreate(_connection->ctx, @"vCard", nil);
    ABStanzaSetAttribute(vcard, @"xmlns", @"vcard-temp");
    
    xmpp_stanza_t *nm = ABStanzaCreate(_connection->ctx, @"NICKNAME", nickname);
    ABStanzaAddChild(vcard, nm);
    
    xmpp_stanza_t *ds = ABStanzaCreate(_connection->ctx, @"DESC", desc);
    ABStanzaAddChild(vcard, ds);
    
    ABStanzaAddChild(iq, vcard);
    
    [self sendData:ABStanzaToData(iq)];
  }
}

@end
