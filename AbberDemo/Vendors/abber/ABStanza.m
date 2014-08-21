//
//  ABStanza.m
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABStanza.h"

@implementation ABStanza

#pragma mark - Memory management

- (id)initWithStanza:(xmpp_stanza_t *)stanza
{
  self = [super init];
  if (self) {
    _stanza = stanza;
  }
  return self;
}

- (void)dealloc
{
  if ( _stanza ) {
    xmpp_stanza_release(_stanza);
    _stanza = NULL;
  }
}



#pragma mark - Public methods

- (xmpp_stanza_t *)stanza
{
  return _stanza;
}

- (void)copyStanza:(xmpp_stanza_t *)stanza
{
  if ( _stanza ) {
    xmpp_stanza_release(_stanza);
    _stanza = NULL;
  }
  
  if ( stanza ) {
    _stanza = xmpp_stanza_copy(stanza);
  }
}

- (void)cloneStanza:(xmpp_stanza_t *)stanza
{
  if ( _stanza ) {
    xmpp_stanza_release(_stanza);
    _stanza = NULL;
  }
  
  if ( stanza ) {
    _stanza = xmpp_stanza_clone(stanza);
  }
}


- (ABStanza *)firstChild
{
  ABStanza *node = nil;
  if ( _stanza ) {
    xmpp_stanza_t *stanza = xmpp_stanza_get_children(_stanza);
    if ( stanza ) {
      node = [[ABStanza alloc] init];
      [node cloneStanza:stanza];
    }
  }
  return node;
}

- (ABStanza *)nextSibling
{
  ABStanza *node = nil;
  if ( _stanza ) {
    xmpp_stanza_t *stanza = xmpp_stanza_get_next(_stanza);
    if ( stanza ) {
      node = [[ABStanza alloc] init];
      [node cloneStanza:stanza];
    }
  }
  return node;
}

- (ABStanza *)childByName:(NSString *)name
{
  ABStanza *node = nil;
  if ( _stanza ) {
    if ( ABOSNonempty(name) ) {
      xmpp_stanza_t *stanza = xmpp_stanza_get_child_by_name(_stanza, ABCString(name));
      if ( stanza ) {
        node = [[ABStanza alloc] init];
        [node cloneStanza:stanza];
      }
    }
  }
  return node;
}

- (ABStanza *)addChild:(ABStanza *)child
{
  if ( _stanza ) {
    if ( (child) && (child.stanza) ) {
      xmpp_stanza_add_child(_stanza, child.stanza);
    }
  }
  return nil;
}


- (NSString *)nodeName
{
  NSString *name = nil;
  if ( _stanza ) {
    char *string = xmpp_stanza_get_name(_stanza);
    if ( string ) {
      name = [[NSString alloc] initWithUTF8String:string];
    }
  }
  return name;
}

- (void)setNodeName:(NSString *)name
{
  if ( _stanza ) {
    if ( ABOSNonempty(name) ) {
      xmpp_stanza_set_name(_stanza, ABCString(name));
    }
  }
}


- (NSString *)textValue
{
  NSString *text = nil;
  if ( _stanza ) {
    char *string = xmpp_stanza_get_text_ptr(_stanza);
    if ( string ) {
      text = [[NSString alloc] initWithUTF8String:string];
    }
  }
  return text;
}

- (void)setTextValue:(NSString *)text
{
  if ( _stanza ) {
    if ( text ) {
      xmpp_stanza_set_text(_stanza, ABCString(text));
    }
  }
}


- (NSString *)valueForAttribute:(NSString *)attr
{
  NSString *value = nil;
  if ( _stanza ) {
    if ( ABOSNonempty(attr) ) {
      char *string = xmpp_stanza_get_attribute(_stanza, ABCString(attr));
      if ( string ) {
        value = [[NSString alloc] initWithUTF8String:string];
      }
    }
  }
  return value;
}

- (void)setValue:(NSString *)value forAttribute:(NSString *)attr
{
  if ( _stanza ) {
    if ( (value) && ABOSNonempty(attr) ) {
      xmpp_stanza_set_attribute(_stanza, ABCString(attr), ABCString(value));
    }
  }
}


- (NSData *)rawData
{
  NSData *data = nil;
  if ( _stanza ) {
    char *buffer = NULL;
    size_t length = 0;
    if ( xmpp_stanza_to_text(_stanza, &buffer, &length)==XMPP_EOK ) {
      if ( length>0 ) {
        data = [[NSData alloc] initWithBytes:buffer length:length];
      }
      xmpp_free(_stanza->ctx, buffer);
    }
  }
  return data;
}

@end
