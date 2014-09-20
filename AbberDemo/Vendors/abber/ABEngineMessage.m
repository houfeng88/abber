//
//  ABEngineMessage.m
//  AbberDemo
//
//  Created by Kevin on 9/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineMessage.h"

#import <GTMBase64/GTMBase64.h>

@interface ABEngine (IncomeMessageNotify)

- (void)didReceiveMessage:(id)msg type:(NSString *)type jid:(NSString *)jid;

@end

@implementation ABEngine (IncomeMessageNotify)

- (void)didReceiveMessage:(id)msg type:(NSString *)type jid:(NSString *)jid
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineMessageDelegate> delegate = [observerAry objectAtIndex:i];
      if ( [delegate respondsToSelector:@selector(engine:didReceiveMessage:type:jid:)] ) {
        [delegate engine:self didReceiveMessage:msg type:type jid:jid];
      }
    }
  });
}

@end

int ABMessageHandler(xmpp_conn_t * const conn,
                     xmpp_stanza_t * const stanza,
                     void * const userdata)
{
  DDLogCDebug(@"[message] Message received.");
  
  ABEngine *engine = (__bridge ABEngine *)userdata;
  
  NSString *type = ABStanzaGetAttribute(stanza, @"type");
  NSString *jid = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));
  
  if ( [@"chat" isEqualToString:type] ) {
    xmpp_stanza_t *body = ABStanzaChildByName(stanza, @"body");
    
    NSString *ctype = ABStanzaGetAttribute(body, @"type");
    NSString *cbody = ABStanzaGetText(body);
    
    if ( [@"audio" isEqualToString:ctype] ) {
      NSData *audio = [GTMBase64 decodeString:cbody];
      [engine didReceiveMessage:audio type:@"audio" jid:jid];
    } else if ( [@"image" isEqualToString:ctype] ) {
      NSData *image = [GTMBase64 decodeString:cbody];
      [engine didReceiveMessage:image type:@"image" jid:jid];
    } else {
      [engine didReceiveMessage:cbody type:@"text" jid:jid];
    }
    
  }
  
  return 1;
}

@implementation ABEngine (IncomeMessage)

- (void)addMessageHandler
{
  xmpp_handler_add(_connection, ABMessageHandler, NULL, "message", NULL, (__bridge void *)self);
}

- (void)removeMessageHandler
{
  xmpp_handler_delete(_connection, ABMessageHandler);
}

@end



@implementation ABEngine (Message)

- (BOOL)sendText:(NSString *)text jid:(NSString *)jid
{
//  <message id='b4vs9km4'
//           to='romeo@example.net'
//           type='chat'>
//    <body>Wherefore art thou, Romeo?</body>
//  </message>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) && TKSNonempty(text) ) {
      NSString *identifier = [[NSUUID UUID] UUIDString];
      
      xmpp_stanza_t *message = ABStanzaCreate(_connection->ctx, @"message", nil);
      ABStanzaSetAttribute(message, @"id", identifier);
      ABStanzaSetAttribute(message, @"type", @"chat");
      ABStanzaSetAttribute(message, @"to", jid);
      
      NSString *ctype = @"text";
      NSString *cbody = text;
      
      xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", cbody);
      ABStanzaSetAttribute(body, @"type", ctype);
      ABStanzaAddChild(message, body);
      
      [self sendData:ABStanzaToData(message)];
    }
    
    return YES;
  }
  return NO;
}

- (BOOL)sendAudio:(NSData *)audio jid:(NSString *)jid
{
//  <message id='b4vs9km4'
//           to='romeo@example.net'
//           type='chat'>
//    <body>Wherefore art thou, Romeo?</body>
//  </message>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) && TKDNonempty(audio) ) {
      NSString *identifier = [[NSUUID UUID] UUIDString];
      
      xmpp_stanza_t *message = ABStanzaCreate(_connection->ctx, @"message", nil);
      ABStanzaSetAttribute(message, @"id", identifier);
      ABStanzaSetAttribute(message, @"type", @"chat");
      ABStanzaSetAttribute(message, @"to", jid);
      
      NSString *ctype = @"audio";
      NSString *cbody = [GTMBase64 stringByEncodingData:audio];
      
      xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", cbody);
      ABStanzaSetAttribute(body, @"type", ctype);
      ABStanzaAddChild(message, body);
      
      [self sendData:ABStanzaToData(message)];
    }
    
    return YES;
  }
  return NO;
}

- (BOOL)sendImage:(NSData *)image jid:(NSString *)jid
{
//  <message id='b4vs9km4'
//           to='romeo@example.net'
//           type='chat'>
//    <body>Wherefore art thou, Romeo?</body>
//  </message>
  if ( [self isConnected] ) {
    if ( TKSNonempty(jid) && TKDNonempty(image) ) {
      NSString *identifier = [[NSUUID UUID] UUIDString];
      
      xmpp_stanza_t *message = ABStanzaCreate(_connection->ctx, @"message", nil);
      ABStanzaSetAttribute(message, @"id", identifier);
      ABStanzaSetAttribute(message, @"type", @"chat");
      ABStanzaSetAttribute(message, @"to", jid);
      
      NSString *ctype = @"image";
      NSString *cbody = [GTMBase64 stringByEncodingData:image];
      
      xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", cbody);
      ABStanzaSetAttribute(body, @"type", ctype);
      ABStanzaAddChild(message, body);
      
      [self sendData:ABStanzaToData(message)];
    }
    
    return YES;
  }
  return NO;
}

@end
