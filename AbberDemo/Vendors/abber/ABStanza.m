//
//  ABStanza.m
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABStanza.h"
#include "internal/abcommon.h"

@implementation ABStanza

- (NSString *)to
{ return [self valueForAttribute:@"to"]; }

- (void)setTo:(NSString *)value
{ [self setValue:value forAttribute:@"to"]; }


- (NSString *)from
{ return [self valueForAttribute:@"from"]; }

- (void)setFrom:(NSString *)value
{ [self setValue:value forAttribute:@"from"]; }


- (NSString *)identifier
{ return [self valueForAttribute:@"id"]; }

- (void)setIdentifier:(NSString *)value
{ [self setValue:value forAttribute:@"id"]; }


- (NSString *)type
{ return [self valueForAttribute:@"type"]; }

- (void)setType:(NSString *)value
{ [self setValue:value forAttribute:@"type"]; }


- (NSString *)language
{ return [self valueForAttribute:@"xml:lang"]; }

- (void)setLanguage:(NSString *)value
{ [self setValue:value forAttribute:@"xml:lang"]; }



+ (ABStanza *)stanzaWithObject:(xmpp_stanza_t *)object
{
  if ( !object ) {
    return nil;
  }
  
  ABStanza *stanza = [[self alloc] init];
  xmpp_stanza_release(stanza->_cstanza);
  stanza->_cstanza = object;
  
  return stanza;
}

- (id)init
{
  self = [super init];
  if (self) {
    _cstanza = xmpp_stanza_new(NULL);
  }
  return self;
}



- (NSString *)valueForAttribute:(NSString *)attr
{
  NSString *value = nil;
  if ( [attr length]>0 ) {
    value = [[NSString alloc] initWithUTF8String:xmpp_stanza_get_attribute(_cstanza, AB_CSTR(attr))];
  }
  return value;
}

- (void)setValue:(NSString *)value forAttribute:(NSString *)attr
{
  if ( [attr length]>0 ) {
    xmpp_stanza_set_attribute(_cstanza, AB_CSTR(attr), AB_CSTR(value));
  }
}

- (NSString *)textValue
{
  return nil;
}

- (void)setTextValue:(NSString *)text
{
}

@end
