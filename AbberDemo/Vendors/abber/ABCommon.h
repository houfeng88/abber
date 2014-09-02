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

// Logger
extern xmpp_log_t ABDefaultLogger;


// Account
NSString *ABAccountPath(NSString *acnt);
void ABSetupAccount(NSString *path);
void ABSetupDatabase(NSString *path);


// Jid
NSString *ABJidCreate(NSString *node, NSString *domain, NSString *resource);
NSString *ABJidBare(NSString *jid);
NSString *ABJidNode(NSString *jid);
NSString *ABJidDomain(NSString *jid);
NSString *ABJidResource(NSString *jid);


// Stanza
xmpp_stanza_t *ABStanzaCreate(xmpp_ctx_t *ctx);
xmpp_stanza_t *ABStanzaCopy(xmpp_stanza_t *stanza);
xmpp_stanza_t *ABStanzaClone(xmpp_stanza_t *stanza);
void           ABStanzaRelease(xmpp_stanza_t *stanza);

xmpp_stanza_t *ABStanzaChildByName(xmpp_stanza_t *stanza, NSString *name);
xmpp_stanza_t *ABStanzaFirstChild(xmpp_stanza_t *stanza);
xmpp_stanza_t *ABStanzaNextChild(xmpp_stanza_t *stanza);
void           ABStanzaAddChild(xmpp_stanza_t *stanza, xmpp_stanza_t *child);

NSString      *ABStanzaGetName(xmpp_stanza_t *stanza);
void           ABStanzaSetName(xmpp_stanza_t *stanza, NSString *name);

NSString      *ABStanzaGetAttribute(xmpp_stanza_t *stanza, NSString *attr);
void           ABStanzaSetAttribute(xmpp_stanza_t *stanza, NSString *attr, NSString *value);

NSString      *ABStanzaGetText(xmpp_stanza_t *stanza);
void           ABStanzaSetText(xmpp_stanza_t *stanza, NSString *text);

NSString      *ABStanzaToString(xmpp_stanza_t *stanza);
NSData        *ABStanzaToData(xmpp_stanza_t *stanza);


// Misc
NSString *ABMakeIdentifier(NSString *domain);


