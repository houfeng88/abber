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
  
  xmpp_stanza_t *iq = xmpp_stanza_new(conn->ctx);
  xmpp_stanza_set_name(iq, "iq");
  xmpp_stanza_set_attribute(iq, "id", xmpp_stanza_get_attribute(stanza, "id"));
  xmpp_stanza_set_attribute(iq, "type", "result");
  xmpp_send(conn, iq);
  xmpp_stanza_release(iq);
  
  
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  xmpp_stanza_t *query = ABStanzaChildByName(stanza, @"query");
  xmpp_stanza_t *item = ABStanzaFirstChild(query);
  if ( item ) {
    
    NSString *jid = ABStanzaGetAttribute(item, @"jid");
    if ( TKSNonempty(jid) ) {
      ABContact *contact = [engine contactByJid:jid];
      if ( !contact ) {
        contact = [[ABContact alloc] init];
      }
      contact.jid = jid;
      contact.memoname = ABStanzaGetAttribute(item, @"name");
      contact.ask = ABStanzaGetAttribute(item, @"ask");
      contact.subscription = ABStanzaGetAttribute(item, @"subscription");
      
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
  
  
  NSMutableArray *roster = [[NSMutableArray alloc] init];
  NSError *error = ABStanzaMakeError(stanza);
  
  if ( !error ) {
    
    xmpp_stanza_t *query = ABStanzaChildByName(stanza, @"query");
    xmpp_stanza_t *item = ABStanzaFirstChild(query);
    while ( item ) {
      
      NSString *jid = ABStanzaGetAttribute(item, @"jid");
      if ( TKSNonempty(jid) ) {
        ABContact *contact = [engine contactByJid:jid];
        if ( !contact ) {
          contact = [[ABContact alloc] init];
        }
        contact.jid = jid;
        contact.memoname = ABStanzaGetAttribute(item, @"name");
        contact.ask = ABStanzaGetAttribute(item, @"ask");
        contact.subscription = ABStanzaGetAttribute(item, @"subscription");
        
        [roster addObject:contact];
      }
      
      item = ABStanzaNextChild(item);
    }
    
  }
  
  [engine saveRoster:roster];
  [engine syncContacts];
  [engine didReceiveRoster:roster error:error completion:completion];
  
  
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
  
  
  NSString *jid = ABJidBare(ABStanzaGetAttribute(stanza, @"to"));
  NSError *error = ABStanzaMakeError(stanza);
  
  [engine didCompleteAddContact:jid error:error completion:completion];
  
  
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
  
  
  NSString *jid = ABJidBare(ABStanzaGetAttribute(stanza, @"to"));
  NSError *error = ABStanzaMakeError(stanza);
  
  [engine didCompleteUpdateContact:jid error:error completion:completion];
  
  
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
  
  
  NSString *jid = ABJidBare(ABStanzaGetAttribute(stanza, @"to"));
  NSError *error = ABStanzaMakeError(stanza);
  
  [engine didCompleteUpdateContact:jid error:error completion:completion];
  
  
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
    
    
    xmpp_stanza_t *iq = ABStanzaCreate(_connection->ctx, @"iq", nil);
    ABStanzaSetAttribute(iq, @"id", identifier);
    ABStanzaSetAttribute(iq, @"type", @"get");
    
    xmpp_stanza_t *query = ABStanzaCreate(_connection->ctx, @"query", nil);
    ABStanzaSetAttribute(query, @"xmlns", @"jabber:iq:roster");
    ABStanzaAddChild(iq, query);
    
    [self sendData:ABStanzaToData(iq)];
    
    return YES;
  }
  return NO;
}

- (BOOL)addContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion
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
      
      
      xmpp_stanza_t *iq = ABStanzaCreate(_connection->ctx, @"iq", nil);
      ABStanzaSetAttribute(iq, @"id", identifier);
      ABStanzaSetAttribute(iq, @"type", @"set");
      
      xmpp_stanza_t *query = ABStanzaCreate(_connection->ctx, @"query", nil);
      ABStanzaSetAttribute(query, @"xmlns", @"jabber:iq:roster");
      ABStanzaAddChild(iq, query);
      
      xmpp_stanza_t *item = ABStanzaCreate(_connection->ctx, @"item", nil);
      ABStanzaSetAttribute(item, @"jid", jid);
      if ( name ) {
        ABStanzaSetAttribute(item, @"name", name);
      }
      ABStanzaAddChild(query, item);
      
      [self sendData:ABStanzaToData(iq)];
      
      return YES;
    }
  }
  return NO;
}

- (BOOL)updateContact:(NSString *)jid name:(NSString *)name completion:(ABEngineCompletionHandler)completion
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
      
      
      xmpp_stanza_t *iq = ABStanzaCreate(_connection->ctx, @"iq", nil);
      ABStanzaSetAttribute(iq, @"id", identifier);
      ABStanzaSetAttribute(iq, @"type", @"set");
      
      xmpp_stanza_t *query = ABStanzaCreate(_connection->ctx, @"query", nil);
      ABStanzaSetAttribute(query, @"xmlns", @"jabber:iq:roster");
      ABStanzaAddChild(iq, query);
      
      xmpp_stanza_t *item = ABStanzaCreate(_connection->ctx, @"item", nil);
      ABStanzaSetAttribute(item, @"jid", jid);
      if ( name ) {
        ABStanzaSetAttribute(item, @"name", name);
      }
      ABStanzaAddChild(query, item);
      
      [self sendData:ABStanzaToData(iq)];
      
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
      
      
      xmpp_stanza_t *iq = ABStanzaCreate(_connection->ctx, @"iq", nil);
      ABStanzaSetAttribute(iq, @"id", identifier);
      ABStanzaSetAttribute(iq, @"type", @"set");
      
      xmpp_stanza_t *query = ABStanzaCreate(_connection->ctx, @"query", nil);
      ABStanzaSetAttribute(query, @"xmlns", @"jabber:iq:roster");
      ABStanzaAddChild(iq, query);
      
      xmpp_stanza_t *item = ABStanzaCreate(_connection->ctx, @"item", nil);
      ABStanzaSetAttribute(item, @"jid", jid);
      ABStanzaSetAttribute(item, @"subscription", @"remove");
      ABStanzaAddChild(query, item);
      
      [self sendData:ABStanzaToData(iq)];
      
      return YES;
    }
  }
  return NO;
}

@end
