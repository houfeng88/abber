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
  DDLogCDebug(@"[vcard] Vcard request complete");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");

  
  NSString *from = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));

  ABContact *contact = [engine contactByJid:from];
  if ( !contact ) {
    contact = [[ABContact alloc] init];
    contact.jid = TKStrOrLater(from, [engine bareJid]);
  }

  xmpp_stanza_t *cvcard = ABStanzaChildByName(stanza, @"vCard");
  xmpp_stanza_t *cdesc = ABStanzaChildByName(cvcard, @"DESC");
  
  NSData *data = [[NSData alloc] initWithBase64EncodedString:ABStanzaGetText(cdesc) options:0];
  NSDictionary *vcard = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
  
  contact.nickname = [vcard objectForKey:@"nickname"];
  contact.desc = [vcard objectForKey:@"desc"];
  
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
  DDLogCDebug(@"[vcard] Vcard update complete");
  
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
    ABStanzaRelease(cvcard);
    
    [self sendData:ABStanzaToData(ciq)];
    ABStanzaRelease(ciq);

    return YES;
  }
  return NO;
}

- (BOOL)updateVcard:(NSDictionary *)vcard completion:(ABEngineCompletionHandler)completion
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
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:vcard options:0 error:NULL];
    NSString *desc = [data base64EncodedStringWithOptions:0];
    
    xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(ciq, @"id", identifier);
    ABStanzaSetAttribute(ciq, @"type", @"set");
    
    xmpp_stanza_t *cvcard = ABStanzaCreate(_connection->ctx, @"vCard", nil);
    ABStanzaSetAttribute(cvcard, @"xmlns", @"vcard-temp");
    
    xmpp_stanza_t *cdesc = ABStanzaCreate(_connection->ctx, @"DESC", desc);
    ABStanzaAddChild(cvcard, cdesc);
    ABStanzaRelease(cdesc);

    ABStanzaAddChild(ciq, cvcard);
    ABStanzaRelease(cvcard);

    [self sendData:ABStanzaToData(ciq)];
    ABStanzaRelease(ciq);

    return YES;
  }
  return NO;
}

@end
