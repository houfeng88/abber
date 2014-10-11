//
//  ABEngineMessage.m
//  AbberDemo
//
//  Created by Kevin on 9/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineMessage.h"

@interface ABEngine (MessageIncomeNotify)

- (void)didReceiveMessage:(ABMessage *)message;

@end

@implementation ABEngine (MessageIncomeNotify)

- (void)didReceiveMessage:(ABMessage *)message
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *observerAry = [self observers];
    for ( NSUInteger i=0; i<[observerAry count]; ++i ) {
      id<ABEngineMessageDelegate> delegate = [observerAry objectAtIndex:i];
        if ( [delegate respondsToSelector:@selector(engine:didReceiveMessage:)] ) {
          [delegate engine:self didReceiveMessage:message];
      }
    }
  });
}

@end

int ABMessageHandler(xmpp_conn_t * const conn,
                     xmpp_stanza_t * const stanza,
                     void * const userdata)
{
  DDLogCDebug(@"[message] Message received");
  
  ABEngine *engine = (__bridge ABEngine *)userdata;

  NSString *from = ABJidBare(ABStanzaGetAttribute(stanza, @"from"));
  if ( TKSNonempty(from) ) {

    if ( ABStanzaIsType(stanza, @"chat") ) {

      ABMessage *message = [[ABMessage alloc] init];
      message.from = from;

      xmpp_stanza_t *cbody = ABStanzaChildByName(stanza, @"body");

      NSString *type = ABStanzaGetAttribute(cbody, @"type");
      if ( [ABMessageAudio isEqualToString:type] ) {
        message.type = ABMessageAudio;
        message.content = ABDataFromBase64String(ABStanzaGetText(cbody));
      } else if ( [ABMessageImage isEqualToString:type] ) {
        message.type = ABMessageImage;
        message.content = ABDataFromBase64String(ABStanzaGetText(cbody));
      } else if ( [ABMessageNudge isEqualToString:type] ) {
        message.type = ABMessageNudge;
        message.content = nil;
      } else {
        message.type = ABMessageText;
        message.content = ABStanzaGetText(cbody);
      }
      
      [engine didReceiveMessage:message];
      
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

- (BOOL)sendMessage:(ABMessage *)message
{
//  <message id='b4vs9km4'
//           to='romeo@example.net'
//           type='chat'>
//    <body>Wherefore art thou, Romeo?</body>
//  </message>
  if ( [self isConnected] ) {
    if ( TKSNonempty(message.to) ) {
      xmpp_stanza_t *cmessage = ABStanzaCreate(_connection->ctx, @"message", nil);
      ABStanzaSetAttribute(cmessage, @"id", [[NSUUID UUID] UUIDString]);
      ABStanzaSetAttribute(cmessage, @"type", @"chat");
      ABStanzaSetAttribute(cmessage, @"to", message.to);

      if ( [ABMessageAudio isEqualToString:message.type] ) {
        xmpp_stanza_t *cbody = ABStanzaCreate(_connection->ctx, @"body", ABBase64StringFromData(message.content));
        ABStanzaSetAttribute(cbody, @"type", ABMessageAudio);
        ABStanzaAddChild(cmessage, cbody);
        ABStanzaRelease(cbody);
      } else if ( [ABMessageImage isEqualToString:message.type] ) {
        xmpp_stanza_t *cbody = ABStanzaCreate(_connection->ctx, @"body", ABBase64StringFromData(message.content));
        ABStanzaSetAttribute(cbody, @"type", ABMessageImage);
        ABStanzaAddChild(cmessage, cbody);
        ABStanzaRelease(cbody);
      } else if ( [ABMessageNudge isEqualToString:message.type] ) {
        xmpp_stanza_t *cbody = ABStanzaCreate(_connection->ctx, @"body", nil);
        ABStanzaSetAttribute(cbody, @"type", ABMessageNudge);
        ABStanzaAddChild(cmessage, cbody);
        ABStanzaRelease(cbody);
      } else {
        xmpp_stanza_t *cbody = ABStanzaCreate(_connection->ctx, @"body", message.content);
        ABStanzaSetAttribute(cbody, @"type", ABMessageText);
        ABStanzaAddChild(cmessage, cbody);
        ABStanzaRelease(cbody);
      }
      
      [self sendData:ABStanzaToData(cmessage)];
      ABStanzaRelease(cmessage);

      return YES;
    }
  }
  return NO;
}

@end
