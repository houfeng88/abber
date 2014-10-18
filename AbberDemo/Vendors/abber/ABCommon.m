//
//  ABCommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABCommon.h"

#pragma mark - Logger

void ABWriteLog(void * const userdata,
                const xmpp_log_level_t level,
                const char * const area,
                const char * const msg)
{
  if ( level==XMPP_LEVEL_DEBUG ) {
    DDLogCDebug(@"[%s] %s", area, msg);
  } else if ( level==XMPP_LEVEL_INFO ) {
    DDLogCInfo (@"[%s] %s", area, msg);
  } else if ( level==XMPP_LEVEL_WARN ) {
    DDLogCWarn (@"[%s] %s", area, msg);
  } else if ( level==XMPP_LEVEL_ERROR ) {
    DDLogCError(@"[%s] %s", area, msg);
  }
}

xmpp_log_t ABDefaultLogger = { &ABWriteLog, NULL };


#pragma mark - Jid

NSString *ABJidCreate(NSString *node, NSString *domain, NSString *resource)
{
  NSString *jid = nil;
  if ( TKSNonempty(node) && TKSNonempty(domain) ) {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:node];
    [string appendFormat:@"@%@", domain];
    if ( TKSNonempty(resource) ) {
      [string appendFormat:@"/%@", resource];
    }
    jid = string;
  }
  return jid;
}

NSString *ABJidBare(NSString *jid)
{
  if ( TKSNonempty(jid) ) {
    if ( [jid containsString:@"/"] ) {
      NSUInteger slashLocation = [jid locationOfString:@"/"];
      NSString *bare = [jid substringToIndex:slashLocation];
      return TKStrOrLater(bare, nil);
    } else {
      return jid;
    }
  }
  return nil;
}

NSString *ABJidNode(NSString *jid)
{
  if ( TKSNonempty(jid) ) {
    
    NSString *node = nil;
    NSString *domain = nil;
    NSString *resource = nil;
    
    NSString *minusNode = nil;
    if ( [jid containsString:@"@"] ) {
      NSUInteger atLocation = [jid locationOfString:@"@"];
      node = [jid substringToIndex:atLocation];
      minusNode = [jid substringFromIndex:atLocation+1];
    } else {
      minusNode = jid;
    }
    
    if ( [minusNode containsString:@"/"] ) {
      NSUInteger slashLocation = [minusNode locationOfString:@"/"];
      domain = [minusNode substringToIndex:slashLocation];
      resource = [minusNode substringFromIndex:slashLocation+1];
    } else {
      domain = minusNode;
    }
    
    return TKStrOrLater(node, nil);
  }
  return nil;
}

NSString *ABJidDomain(NSString *jid)
{
  if ( TKSNonempty(jid) ) {
    
    NSString *node = nil;
    NSString *domain = nil;
    NSString *resource = nil;
    
    NSString *minusNode = nil;
    if ( [jid containsString:@"@"] ) {
      NSUInteger atLocation = [jid locationOfString:@"@"];
      node = [jid substringToIndex:atLocation];
      minusNode = [jid substringFromIndex:atLocation+1];
    } else {
      minusNode = jid;
    }
    
    if ( [minusNode containsString:@"/"] ) {
      NSUInteger slashLocation = [minusNode locationOfString:@"/"];
      domain = [minusNode substringToIndex:slashLocation];
      resource = [minusNode substringFromIndex:slashLocation+1];
    } else {
      domain = minusNode;
    }
    
    return TKStrOrLater(domain, nil);
    
  }
  return nil;
}

NSString *ABJidResource(NSString *jid)
{
  if ( TKSNonempty(jid) ) {
    
    NSString *node = nil;
    NSString *domain = nil;
    NSString *resource = nil;
    
    NSString *minusNode = nil;
    if ( [jid containsString:@"@"] ) {
      NSUInteger atLocation = [jid locationOfString:@"@"];
      node = [jid substringToIndex:atLocation];
      minusNode = [jid substringFromIndex:atLocation+1];
    } else {
      minusNode = jid;
    }
    
    if ( [minusNode containsString:@"/"] ) {
      NSUInteger slashLocation = [minusNode locationOfString:@"/"];
      domain = [minusNode substringToIndex:slashLocation];
      resource = [minusNode substringFromIndex:slashLocation+1];
    } else {
      domain = minusNode;
    }
    
    return TKStrOrLater(resource, nil);
  }
  return nil;
}


#pragma mark - Stanza

xmpp_stanza_t *ABStanzaCreate(xmpp_ctx_t *ctx, NSString *name, NSString *text)
{
  xmpp_stanza_t *st = NULL;
  if ( ctx ) {
    st = xmpp_stanza_new(ctx);
    ABStanzaSetName(st, name);
    ABStanzaSetText(st, text);
  }
  return st;
}

xmpp_stanza_t *ABStanzaCopy(xmpp_stanza_t *stanza)
{
  xmpp_stanza_t *st = NULL;
  if ( stanza ) {
    st = xmpp_stanza_copy(stanza);
  }
  return st;
}

xmpp_stanza_t *ABStanzaClone(xmpp_stanza_t *stanza)
{
  xmpp_stanza_t *st = NULL;
  if ( stanza ) {
    st = xmpp_stanza_clone(stanza);
  }
  return st;
}

void           ABStanzaRelease(xmpp_stanza_t *stanza)
{
  if ( stanza ) {
    xmpp_stanza_release(stanza);
  }
}


xmpp_stanza_t *ABStanzaChildByName(xmpp_stanza_t *stanza, NSString *name)
{
  xmpp_stanza_t *st = NULL;
  if ( stanza ) {
    if ( TKSNonempty(name) ) {
      st = xmpp_stanza_get_child_by_name(stanza, TKCString(name));
    }
  }
  return st;
}

xmpp_stanza_t *ABStanzaFirstChild(xmpp_stanza_t *stanza)
{
  xmpp_stanza_t *st = NULL;
  if ( stanza ) {
    st = xmpp_stanza_get_children(stanza);
  }
  return st;
}

xmpp_stanza_t *ABStanzaNextChild(xmpp_stanza_t *stanza)
{
  xmpp_stanza_t *st = NULL;
  if ( stanza ) {
    st = xmpp_stanza_get_next(stanza);
  }
  return st;
}

void           ABStanzaAddChild(xmpp_stanza_t *stanza, xmpp_stanza_t *child)
{
  if ( stanza ) {
    if ( child ) {
      xmpp_stanza_add_child(stanza, child);
    }
  }
}


NSString      *ABStanzaGetName(xmpp_stanza_t *stanza)
{
  NSString *name = nil;
  if ( stanza ) {
    char *string = xmpp_stanza_get_name(stanza);
    if ( (string) && (strlen(string)>0) ) {
      name = TKOString(string);
    }
  }
  return name;
}

void           ABStanzaSetName(xmpp_stanza_t *stanza, NSString *name)
{
  if ( stanza ) {
    if ( TKSNonempty(name) ) {
      xmpp_stanza_set_name(stanza, TKCString(name));
    }
  }
}


NSString      *ABStanzaGetAttribute(xmpp_stanza_t *stanza, NSString *attr)
{
  NSString *value = nil;
  if ( stanza ) {
    if ( TKSNonempty(attr) ) {
      char *string = xmpp_stanza_get_attribute(stanza, TKCString(attr));
      value = TKOString(string);
    }
  }
  return value;
}

void           ABStanzaSetAttribute(xmpp_stanza_t *stanza, NSString *attr, NSString *value)
{
  if ( stanza ) {
    if ( TKSNonempty(attr) ) {
      if ( value ) {
        xmpp_stanza_set_attribute(stanza, TKCString(attr), TKCString(value));
      }
    }
  }
}


NSString      *ABStanzaGetText(xmpp_stanza_t *stanza)
{
  NSString *text = nil;
  if ( stanza ) {
    NSMutableString *buffer = [[NSMutableString alloc] init];
    xmpp_stanza_t *child = xmpp_stanza_get_children(stanza);
    while ( child ) {
      char *string = xmpp_stanza_get_text_ptr(child);
      NSString *segment = TKOString(string);
      if ( TKSNonempty(segment) ) {
        [buffer appendString:segment];
      }
      child = child->next;
    }
    text = TKStrOrLater(buffer, nil);
  }
  return text;
}

void           ABStanzaSetText(xmpp_stanza_t *stanza, NSString *text)
{
  if ( stanza ) {
    if ( text ) {
      xmpp_stanza_t *child = xmpp_stanza_get_children(stanza);
      if ( (child) && (child->next==NULL) ) {
        stanza->children = NULL;
        xmpp_stanza_release(child);
        child = NULL;
      }
      
      child = xmpp_stanza_get_children(stanza);
      if ( !child ) {
        xmpp_stanza_t *st = xmpp_stanza_new(stanza->ctx);
        xmpp_stanza_set_text(st, TKCString(text));
        xmpp_stanza_add_child(stanza, st);
        xmpp_stanza_release(st);
      }
    }
  }
}


NSString      *ABStanzaToString(xmpp_stanza_t *stanza)
{
  NSString *string = nil;
  if ( stanza ) {
    char *buffer = NULL;
    size_t length = 0;
    if ( xmpp_stanza_to_text(stanza, &buffer, &length)==XMPP_EOK ) {
      if ( buffer ) {
        if ( length>0 ) {
          string = [[NSString alloc] initWithBytes:buffer length:length encoding:NSUTF8StringEncoding];
        }
        xmpp_free(stanza->ctx, buffer);
      }
    }
  }
  return string;
}

NSData        *ABStanzaToData(xmpp_stanza_t *stanza)
{
  NSData *data = nil;
  if ( stanza ) {
    char *buffer = NULL;
    size_t length = 0;
    if ( xmpp_stanza_to_text(stanza, &buffer, &length)==XMPP_EOK ) {
      if ( buffer ) {
        if ( length>0 ) {
          data = [[NSData alloc] initWithBytes:buffer length:length];
        }
        xmpp_free(stanza->ctx, buffer);
      }
    }
  }
  return data;
}


NSError       *ABStanzaMakeError(xmpp_stanza_t *stanza)
{
  NSError *error = nil;
  
  xmpp_stanza_t *errorNode = ABStanzaChildByName(stanza, @"error");
  if ( errorNode ) {
    xmpp_stanza_t *descNode = ABStanzaFirstChild(errorNode);
    if ( descNode ) {
      NSString *name = ABStanzaGetName(descNode);
      NSDictionary *userInfo = @{ @"ABErrorDescriptionKey": TKStrOrLater(name, @"") };
      
      error = [NSError errorWithDomain:@"abber.org" code:1 userInfo:userInfo];
    }
  }
  
  return error;
}

BOOL           ABStanzaIsType(xmpp_stanza_t *stanza, NSString *type)
{
  if ( TKSNonempty(type) ) {
    return [type isEqualToString:ABStanzaGetAttribute(stanza, @"type")];
  }
  return NO;
}


#pragma mark - Handler context

void *ABHandlexCreate()
{
  NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
  CFDictionaryRef dictionaryRef = (__bridge_retained CFDictionaryRef)dictionary;
  return (void *)dictionaryRef;
}

void  ABHandlexDestroy(void *contextRef)
{
  CFDictionaryRef dictionaryRef = (CFDictionaryRef)contextRef;
  CFRelease(dictionaryRef);
}

void *ABHandlexGetObject(void *contextRef, NSString *key)
{
  if ( contextRef ) {
    CFMutableDictionaryRef dictionaryRef = (CFMutableDictionaryRef)contextRef;
    NSMutableDictionary *dictionary = (__bridge NSMutableDictionary *)dictionaryRef;
    return (__bridge void *)[dictionary objectForKey:key];
  }
  return NULL;
}

void  ABHandlexSetObject(void *contextRef, NSString *key, id object)
{
  if ( contextRef ) {
    CFMutableDictionaryRef dictionaryRef = (CFMutableDictionaryRef)contextRef;
    NSMutableDictionary *dictionary = (__bridge NSMutableDictionary *)dictionaryRef;
    [dictionary setObject:object forKey:key];
  }
}

void *ABHandlexGetNonretainedObject(void *contextRef, NSString *key)
{
  if ( contextRef ) {
    CFMutableDictionaryRef dictionaryRef = (CFMutableDictionaryRef)contextRef;
    NSMutableDictionary *dictionary = (__bridge NSMutableDictionary *)dictionaryRef;
    NSValue *value = [dictionary objectForKey:key];
    return (__bridge void *)[value nonretainedObjectValue];
  }
  return NULL;
}

void  ABHandlexSetNonretainedObject(void *contextRef, NSString *key, id object)
{
  NSValue *value = [NSValue valueWithNonretainedObject:object];
  ABHandlexSetObject(contextRef, key, value);
}


#pragma mark - Encode and decode

NSString     *ABBase64StringFromData(NSData *data)
{
  NSString *string = nil;
  if ( data ) {
    string = [data base64EncodedStringWithOptions:0];
  }
  return string;
}

NSString     *ABBase64StringFromDictionary(NSDictionary *dictionary)
{
  NSString *string = nil;
  if ( dictionary ) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
    string = ABBase64StringFromData(data);
  }
  return string;
}

NSData       *ABDataFromBase64String(NSString *string)
{
  NSData *data = nil;
  if ( string ) {
    data = [[NSData alloc] initWithBase64EncodedString:string options:0];
  }
  return data;
}

NSDictionary *ABDictionaryFromBase64String(NSString *string)
{
  NSDictionary *dictionary = nil;
  NSData *data = ABDataFromBase64String(string);
  if ( data ) {
    dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
  }
  return dictionary;
}
