//
//  ABStanza.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCommon.h"

@interface ABStanza : NSObject {
  xmpp_stanza_t *_stanza;
}

@property (nonatomic, assign) xmpp_stanza_t *stanza;

@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *language;

- (NSData *)raw;

- (ABStanza *)firstChild;
- (ABStanza *)nextSibling;
- (ABStanza *)childByName:(NSString *)name;
- (ABStanza *)addChild:(ABStanza *)child;

- (NSString *)nodeName;
- (void)setNodeName:(NSString *)name;

- (NSString *)textValue;
- (void)setTextValue:(NSString *)text;

- (NSString *)valueForAttribute:(NSString *)attr;
- (void)setValue:(NSString *)value forAttribute:(NSString *)attr;

@end
