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


#pragma mark - Account

NSString *ABAccountPath(NSString *acnt)
{
  if ( TKSNonempty(acnt) ) {
    return TKPathForDocumentResource(acnt);
  }
  return nil;
}

void ABSetupAccount(NSString *path)
{
  if ( TKSNonempty(path) ) {
    TKCreateDirectory(path);
  }
}

void ABSetupDatabase(NSString *path)
{
  if ( TKSNonempty(path) ) {
    
    FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
    
    [db open];
    
    
    NSString *contactSQL =
    @"CREATE TABLE IF NOT EXISTS contact("
    @"pk INTEGER PRIMARY KEY, "
    @"jid TEXT, "
    @"memoname TEXT, "
    @"relation INTEGER);";
    [db executeUpdate:contactSQL];
    
  }
}


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

xmpp_stanza_t *ABStanzaCreate(xmpp_ctx_t *ctx)
{
  xmpp_stanza_t *st = NULL;
  if ( ctx ) {
    st = xmpp_stanza_new(ctx);
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
    xmpp_stanza_t *child = xmpp_stanza_get_children(stanza);
    if ( (child) && (child->next==NULL) ) {
      char *string = xmpp_stanza_get_text_ptr(child);
      text = TKOString(string);
    }
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


#pragma mark - Misc

NSString *ABMakeIdentifier(NSString *domain)
{
  NSString *identifier = nil;
  if ( TKSNonempty(domain) ) {
    identifier = [[NSMutableString alloc] init];
    
    [(NSMutableString *)identifier appendString:domain];
    
    [(NSMutableString *)identifier appendString:@"-"];
    
    [(NSMutableString *)identifier appendString:[[NSUUID UUID] UUIDString]];
  }
  return identifier;
}
