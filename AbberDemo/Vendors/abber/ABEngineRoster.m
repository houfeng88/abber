//
//  ABEngineRoster.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineRoster.h"

#import "ABEngineStorage.h"

@interface ABEngine (RosterIncomeNotify)

- (void)didReceiveRosterUpdate:(ABContact *)contact;

@end

@implementation ABEngine (RosterIncomeNotify)

- (void)didReceiveRosterUpdate:(ABContact *)contact
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveRosterUpdate:)] ) {
        [delegate engine:self didReceiveRosterUpdate:contact];
      }
    }
  });
}

@end

int ABRosterPushHandler(xmpp_conn_t * const conn,
                        xmpp_stanza_t * const stanza,
                        void * const userdata)
{
  DDLogCDebug(@"[roster] Roster push received.");
  
  xmpp_stanza_t *ciq = xmpp_stanza_new(conn->ctx);
  xmpp_stanza_set_name(ciq, "iq");
  xmpp_stanza_set_attribute(ciq, "id", xmpp_stanza_get_attribute(stanza, "id"));
  xmpp_stanza_set_attribute(ciq, "type", "result");
  xmpp_send(conn, ciq);
  xmpp_stanza_release(ciq);
  
  
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  xmpp_stanza_t *cquery = ABStanzaChildByName(stanza, @"query");
  xmpp_stanza_t *citem = ABStanzaFirstChild(cquery);
  if ( citem ) {
    
    NSString *jid = ABStanzaGetAttribute(citem, @"jid");
    if ( TKSNonempty(jid) ) {
      ABContact *contact = [engine contactByJid:jid];
      if ( !contact ) {
        contact = [[ABContact alloc] init];
        contact.jid = jid;
      }
      contact.memoname = ABStanzaGetAttribute(citem, @"name");
      contact.ask = ABStanzaGetAttribute(citem, @"ask");
      contact.subscription = ABStanzaGetAttribute(citem, @"subscription");
      
      if ( [@"remove" isEqualToString:contact.subscription] ) {
        [engine deleteContactByJid:jid];
        [engine syncContacts];
        [engine didReceiveRosterUpdate:contact];
      } else {
        [engine saveContact:contact];
        [engine syncContacts];
        [engine didReceiveRosterUpdate:contact];
      }
    }
    
  }
  
  return 1;
}

@implementation ABEngine (RosterIncome)

- (void)addRosterPushHandler
{
  xmpp_handler_add(_connection, ABRosterPushHandler, "jabber:iq:roster", "iq", "set", (__bridge void *)self);
}

- (void)removeRosterPushHandler
{
  xmpp_handler_delete(_connection, ABRosterPushHandler);
}

@end



@interface ABEngine (RosterNotify)

- (void)didReceiveRoster:(NSArray *)roster error:(NSError *)error completion:(ABEngineCompletionHandler)completion;
- (void)didCompleteAddContact:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion;
- (void)didCompleteUpdateContact:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion;
- (void)didCompleteRemoveContact:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion;

@end

@implementation ABEngine (RosterNotify)

- (void)didReceiveRoster:(NSArray *)roster error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveRoster:error:)] ) {
        [delegate engine:self didReceiveRoster:roster error:error];
      }
    }
    if ( completion ) {
      completion(roster, error);
    }
  });
}

- (void)didCompleteAddContact:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteAddContact:error:)] ) {
        [delegate engine:self didCompleteAddContact:jid error:error];
      }
    }
    if ( completion ) {
      completion(jid, error);
    }
  });
}

- (void)didCompleteUpdateContact:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteUpdateContact:error:)] ) {
        [delegate engine:self didCompleteUpdateContact:jid error:error];
      }
    }
    if ( completion ) {
      completion(jid, error);
    }
  });
}

- (void)didCompleteRemoveContact:(NSString *)jid error:(NSError *)error completion:(ABEngineCompletionHandler)completion
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineRosterDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didCompleteRemoveContact:error:)] ) {
        [delegate engine:self didCompleteRemoveContact:jid error:error];
      }
    }
    if ( completion ) {
      completion(jid, error);
    }
  });
}

@end

int ABRosterRequestHandler(xmpp_conn_t * const conn,
                           xmpp_stanza_t * const stanza,
                           void * const userdata)
{
  DDLogCDebug(@"[roster] Roster request complete.");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");
  

  NSError *error = ABStanzaMakeError(stanza);
  
  if ( error ) {

    [engine didReceiveRoster:nil error:error completion:completion];
    
  } else {

    NSMutableArray *roster = [[NSMutableArray alloc] init];

    xmpp_stanza_t *cquery = ABStanzaChildByName(stanza, @"query");
    xmpp_stanza_t *citem = ABStanzaFirstChild(cquery);
    while ( citem ) {

      NSString *jid = ABStanzaGetAttribute(citem, @"jid");
      if ( TKSNonempty(jid) ) {
        ABContact *contact = [engine contactByJid:jid];
        if ( !contact ) {
          contact = [[ABContact alloc] init];
          contact.jid = jid;
        }
        contact.memoname = ABStanzaGetAttribute(citem, @"name");
        contact.ask = ABStanzaGetAttribute(citem, @"ask");
        contact.subscription = ABStanzaGetAttribute(citem, @"subscription");

        [roster addObject:contact];
      }

      citem = ABStanzaNextChild(citem);
    }

    [engine saveRoster:roster];
    [engine syncContacts];
    [engine didReceiveRoster:roster error:error completion:completion];

  }
  
  
  ABHandlexDestroy(userdata);
  return 0;
}

int ABRosterAddHandler(xmpp_conn_t * const conn,
                       xmpp_stanza_t * const stanza,
                       void * const userdata)
{
  DDLogCDebug(@"[roster] Roster add complete.");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");
  

  [engine didCompleteUpdateContact:ABJidBare(ABStanzaGetAttribute(stanza, @"to"))
                             error:ABStanzaMakeError(stanza)
                        completion:completion];
  
  
  ABHandlexDestroy(userdata);
  return 0;
}

int ABRosterUpdateHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"[roster] Roster update complete.");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");


  [engine didCompleteUpdateContact:ABJidBare(ABStanzaGetAttribute(stanza, @"to"))
                             error:ABStanzaMakeError(stanza)
                        completion:completion];
  
  
  ABHandlexDestroy(userdata);
  return 0;
}

int ABRosterRemoveHandler(xmpp_conn_t * const conn,
                          xmpp_stanza_t * const stanza,
                          void * const userdata)
{
  DDLogCDebug(@"[roster] Roster remove complete.");
  
  ABEngine *engine = (__bridge id)ABHandlexGetNonretainedObject(userdata, @"engine");
  ABEngineCompletionHandler completion = (__bridge id)ABHandlexGetObject(userdata, @"completion");
  

  [engine didCompleteUpdateContact:ABJidBare(ABStanzaGetAttribute(stanza, @"to"))
                             error:ABStanzaMakeError(stanza)
                        completion:completion];
  
  
  ABHandlexDestroy(userdata);
  return 0;
}

@implementation ABEngine (Roster)

- (BOOL)requestRosterWithCompletion:(ABEngineCompletionHandler)completion
{
//  <iq id='bv1bs71f' type='get'>
//    <query xmlns='jabber:iq:roster'/>
//  </iq>
  if ( [self isConnected] ) {
    NSString *identifier = [[NSUUID UUID] UUIDString];
    
    void *contextRef = ABHandlexCreate();
    ABHandlexSetNonretainedObject(contextRef, @"engine", self);
    if ( completion ) ABHandlexSetObject(contextRef, @"completion", [completion copy]);
    
    xmpp_id_handler_add(_connection, ABRosterRequestHandler, TKCString(identifier), contextRef);
    
    
    xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(ciq, @"id", identifier);
    ABStanzaSetAttribute(ciq, @"type", @"get");
    
    xmpp_stanza_t *cquery = ABStanzaCreate(_connection->ctx, @"query", nil);
    ABStanzaSetAttribute(cquery, @"xmlns", @"jabber:iq:roster");
    ABStanzaAddChild(ciq, cquery);
    ABStanzaRelease(cquery);
    
    [self sendData:ABStanzaToData(ciq)];
    ABStanzaRelease(ciq);
    
    return YES;
  }
  return NO;
}

- (BOOL)addContact:(NSString *)jid memoname:(NSString *)memoname completion:(ABEngineCompletionHandler)completion
{
//  <iq id='ph1xaz53' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'/>
//    </query>
//  </iq>
  if ( TKSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *identifier = [[NSUUID UUID] UUIDString];
      
      void *contextRef = ABHandlexCreate();
      ABHandlexSetNonretainedObject(contextRef, @"engine", self);
      if ( completion ) ABHandlexSetObject(contextRef, @"completion", [completion copy]);
      
      xmpp_id_handler_add(_connection, ABRosterAddHandler, TKCString(identifier), contextRef);
      
      
      xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
      ABStanzaSetAttribute(ciq, @"id", identifier);
      ABStanzaSetAttribute(ciq, @"type", @"set");
      
      xmpp_stanza_t *cquery = ABStanzaCreate(_connection->ctx, @"query", nil);
      ABStanzaSetAttribute(cquery, @"xmlns", @"jabber:iq:roster");
      
      xmpp_stanza_t *citem = ABStanzaCreate(_connection->ctx, @"item", nil);
      ABStanzaSetAttribute(citem, @"jid", jid);
      if ( memoname ) {
        ABStanzaSetAttribute(citem, @"name", memoname);
      }
      ABStanzaAddChild(cquery, citem);
      ABStanzaRelease(citem);

      ABStanzaAddChild(ciq, cquery);
      ABStanzaRelease(cquery);
      
      [self sendData:ABStanzaToData(ciq)];
      ABStanzaRelease(ciq);
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)updateContact:(NSString *)jid memoname:(NSString *)memoname completion:(ABEngineCompletionHandler)completion
{
//  <iq id='ph1xaz53' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' name='Nurse'/>
//    </query>
//  </iq>
  if ( TKSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *identifier = [[NSUUID UUID] UUIDString];
      
      void *contextRef = ABHandlexCreate();
      ABHandlexSetNonretainedObject(contextRef, @"engine", self);
      if ( completion ) ABHandlexSetObject(contextRef, @"completion", [completion copy]);
      
      xmpp_id_handler_add(_connection, ABRosterUpdateHandler, TKCString(identifier), contextRef);
      
      
      xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
      ABStanzaSetAttribute(ciq, @"id", identifier);
      ABStanzaSetAttribute(ciq, @"type", @"set");
      
      xmpp_stanza_t *cquery = ABStanzaCreate(_connection->ctx, @"query", nil);
      ABStanzaSetAttribute(cquery, @"xmlns", @"jabber:iq:roster");
      
      xmpp_stanza_t *citem = ABStanzaCreate(_connection->ctx, @"item", nil);
      ABStanzaSetAttribute(citem, @"jid", jid);
      if ( memoname ) {
        ABStanzaSetAttribute(citem, @"name", memoname);
      }
      ABStanzaAddChild(cquery, citem);
      ABStanzaRelease(citem);

      ABStanzaAddChild(ciq, cquery);
      ABStanzaRelease(cquery);
      
      [self sendData:ABStanzaToData(ciq)];
      ABStanzaRelease(ciq);
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)removeContact:(NSString *)jid completion:(ABEngineCompletionHandler)completion
{
//  <iq id='hm4hs97y' type='set'>
//    <query xmlns='jabber:iq:roster'>
//      <item jid='nurse@example.com' subscription='remove'/>
//    </query>
//  </iq>
  if ( TKSNonempty(jid) ) {
    if ( [self isConnected] ) {
      NSString *identifier = [[NSUUID UUID] UUIDString];
      
      void *contextRef = ABHandlexCreate();
      ABHandlexSetNonretainedObject(contextRef, @"engine", self);
      if ( completion ) ABHandlexSetObject(contextRef, @"completion", [completion copy]);
      
      xmpp_id_handler_add(_connection, ABRosterRemoveHandler, TKCString(identifier), contextRef);
      
      
      xmpp_stanza_t *ciq = ABStanzaCreate(_connection->ctx, @"iq", nil);
      ABStanzaSetAttribute(ciq, @"id", identifier);
      ABStanzaSetAttribute(ciq, @"type", @"set");
      
      xmpp_stanza_t *cquery = ABStanzaCreate(_connection->ctx, @"query", nil);
      ABStanzaSetAttribute(cquery, @"xmlns", @"jabber:iq:roster");
      
      xmpp_stanza_t *citem = ABStanzaCreate(_connection->ctx, @"item", nil);
      ABStanzaSetAttribute(citem, @"jid", jid);
      ABStanzaSetAttribute(citem, @"subscription", @"remove");
      ABStanzaAddChild(cquery, citem);
      ABStanzaRelease(citem);

      ABStanzaAddChild(ciq, cquery);
      ABStanzaRelease(cquery);
      
      [self sendData:ABStanzaToData(ciq)];
      ABStanzaRelease(ciq);
      
      return YES;
    }
  }
  return NO;
}

@end
