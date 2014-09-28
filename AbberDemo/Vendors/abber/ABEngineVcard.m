//
//  ABEngineVcard.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineVcard.h"

#import "ABEngineStorage.h"

@interface ABEngine (VcardNotify)

- (void)didReceiveVcard:(ABContact *)vcard error:(NSError *)error completion:(ABEngineCompletionHandler)completion;
- (void)didCompleteUpdateVcard:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion;

@end

@implementation ABEngine (VcardNotify)

- (void)didReceiveVcard:(ABContact *)contact error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineVcardDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveVcard:error:)] ) {
        [delegate engine:self didReceiveVcard:contact error:error];
      }
    }
    if ( completion ) {
      completion(contact, error);
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

  
  NSString *from = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));

  ABContact *contact = [engine contactByJid:from];
  if ( !contact ) {
    contact = [[ABContact alloc] init];
    contact.jid = TKStrOrLater(from, [engine bareJid]);
  }

  xmpp_stanza_t *cvcard = ABStanzaChildByName(stanza, @"vCard");

  xmpp_stanza_t *cnickname = ABStanzaChildByName(cvcard, @"NICKNAME");
  contact.nickname = ABStanzaGetText(cnickname);

  xmpp_stanza_t *cdesc = ABStanzaChildByName(cvcard, @"DESC");
  contact.desc = ABStanzaGetText(cdesc);
  
  [engine didReceiveVcard:contact
                    error:nil
               completion:completion];
  
  
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


  [engine didCompleteUpdateVcard:ABJidBare(ABStanzaGetAttribute(stanza, @"to"))
                           error:ABStanzaMakeError(stanza)
                      completion:completion];
  
  
  ABHandlexDestroy(userdata);
  return 0;
}

@implementation ABEngine (Vcard)

- (BOOL)requestVcard:(NSString *)jid completion:(ABEngineCompletionHandler)completion
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
    
    
    xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(ciq, @"id", identifier);
    ABStanzaSetAttribute(ciq, @"type", @"get");
    ABStanzaSetAttribute(ciq, @"from", [self boundJid]);
    ABStanzaSetAttribute(ciq, @"to", TKStrOrLater(jid, nil));
    
    xmpp_stanza_t *cvcard = ABStanzaCreate(_connection->ctx, @"vCard", nil);
    ABStanzaSetAttribute(cvcard, @"xmlns", @"vcard-temp");
    ABStanzaAddChild(ciq, cvcard);
    
    [self sendData:ABStanzaToData(ciq)];

    return YES;
  }
  return NO;
}

- (BOOL)updateVcardWithNickname:(NSString *)nickname desc:(NSString *)desc completion:(ABEngineCompletionHandler)completion
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
    
    
    xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(ciq, @"id", identifier);
    ABStanzaSetAttribute(ciq, @"type", @"set");
    
    xmpp_stanza_t *cvcard = ABStanzaCreate(_connection->ctx, @"vCard", nil);
    ABStanzaSetAttribute(cvcard, @"xmlns", @"vcard-temp");
    ABStanzaAddChild(ciq, cvcard);

    xmpp_stanza_t *cnickname = ABStanzaCreate(_connection->ctx, @"NICKNAME", nickname);
    ABStanzaAddChild(cvcard, cnickname);

    xmpp_stanza_t *cdesc = ABStanzaCreate(_connection->ctx, @"DESC", desc);
    ABStanzaAddChild(cvcard, cdesc);
    
    [self sendData:ABStanzaToData(ciq)];

    return YES;
  }
  return NO;
}

@end
