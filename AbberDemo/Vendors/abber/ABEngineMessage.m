//
//  ABEngineMessage.m
//  AbberDemo
//
//  Created by Kevin on 9/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineMessage.h"

@interface ABEngine (MessageIncomeNotify)

- (void)didReceiveMessage:(ABMessage *)msg;

@end

@implementation ABEngine (MessageIncomeNotify)

- (void)didReceiveMessage:(ABMessage *)msg
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineMessageDelegate> delegate = [observerAry objectAtIndex:i];
        if ( [delegate respondsToSelector:@selector(engine:didReceiveMessage:)] ) {
          [delegate engine:self didReceiveMessage:msg];
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

  NSString *from = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));
  if ( TKSNonempty(from) ) {

    if ( ABStanzaIsType(stanza, @"chat") ) {

      ABMessage *msg = [[ABMessage alloc] init];
      msg.from = from;

      xmpp_stanza_t *body = ABStanzaChildByName(stanza, @"body");

      NSString *type = ABStanzaGetAttribute(body, @"type");
      if ( [ABMessageAudio isEqualToString:type] ) {
        msg.type = ABMessageAudio;
        msg.content = [[NSData alloc] initWithBase64EncodedString:ABStanzaGetText(body) options:0];
      } else if ( [ABMessageImage isEqualToString:type] ) {
        msg.type = ABMessageImage;
        msg.content = [[NSData alloc] initWithBase64EncodedString:ABStanzaGetText(body) options:0];
      } else if ( [ABMessageNudge isEqualToString:type] ) {
        msg.type = ABMessageNudge;
        msg.content = nil;
      } else {
        msg.type = ABMessageText;
        msg.content = ABStanzaGetText(body);
      }
      
      [engine didReceiveMessage:msg];
      
    }
  }
  
  return 1;
}

@implementation ABEngine (MessageIncome)

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

- (BOOL)sendMessage:(ABMessage *)msg
{
//  <message id='b4vs9km4'
//           to='romeo@example.net'
//           type='chat'>
//    <body>Wherefore art thou, Romeo?</body>
//  </message>
  if ( [self isConnected] ) {
    if ( TKSNonempty(msg.to) ) {
      xmpp_stanza_t *message = ABStanzaCreate(_connection->ctx, @"message", nil);
      ABStanzaSetAttribute(message, @"id", [[NSUUID UUID] UUIDString]);
      ABStanzaSetAttribute(message, @"type", @"chat");
      ABStanzaSetAttribute(message, @"to", msg.to);

      if ( [ABMessageAudio isEqualToString:msg.type] ) {
        xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", [msg.content base64EncodedStringWithOptions:0]);
        ABStanzaSetAttribute(body, @"type", ABMessageAudio);
        ABStanzaAddChild(message, body);
      } else if ( [ABMessageImage isEqualToString:msg.type] ) {
        xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", [msg.content base64EncodedStringWithOptions:0]);
        ABStanzaSetAttribute(body, @"type", ABMessageImage);
        ABStanzaAddChild(message, body);
      } else if ( [ABMessageNudge isEqualToString:msg.type] ) {
        xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", nil);
        ABStanzaSetAttribute(body, @"type", ABMessageNudge);
        ABStanzaAddChild(message, body);
      } else {
        xmpp_stanza_t *body = ABStanzaCreate(_connection->ctx, @"body", msg.content);
        ABStanzaSetAttribute(body, @"type", ABMessageText);
        ABStanzaAddChild(message, body);
      }
      
      [self sendData:ABStanzaToData(message)];

      return YES;
    }
  }
  return NO;
}

@end
