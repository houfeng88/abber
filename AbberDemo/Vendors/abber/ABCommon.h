//
//  ABCommon.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>
#include <strophe/common.h>

// Macros
#define ABCString(a)  ((!a)?(NULL):([a UTF8String]))
#define ABOString(a)  ((!a)?(nil ):([[NSString alloc] initWithUTF8String:a]))

#define ABCSNonempty(a)   (((a)!=NULL)&&(strlen(a)>0))
#define ABOSNonempty(a)   (((a)!=nil )&&([(a) length]>0))

#define ABCStrOrLater(a,b)  ((((a)!=NULL)&&(strlen(a)>0))?(a):(b))
#define ABOStrOrLater(a,b)  ((((a)!=nil )&&([(a) length]>0))?(a):(b))


// Logger
extern xmpp_log_t ABDefaultLogger;


// Stanza
xmpp_stanza_t *ABStanzaCreate(xmpp_ctx_t *ctx);
xmpp_stanza_t *ABStanzaCopy(xmpp_ctx_t *ctx);
xmpp_stanza_t *ABStanzaClone(xmpp_ctx_t *ctx);
void           ABStanzaRelease(xmpp_ctx_t *ctx);

NSString      *ABStanzaGetName(xmpp_stanza_t *stanza);
void           ABStanzaSetName(xmpp_stanza_t *stanza, NSString *name);

NSString      *ABStanzaGetAttribute(xmpp_stanza_t *stanza, NSString *attr);
void           ABStanzaSetAttribute(xmpp_stanza_t *stanza, NSString *attr, NSString *value);

NSString      *ABStanzaGetText(xmpp_stanza_t *stanza);
void           ABStanzaSetText(xmpp_stanza_t *stanza, NSString *text);

NSString      *ABStanzaToString(xmpp_stanza_t *stanza);


// Misc
NSString *ABMakeIdentifier(NSString *domain);


