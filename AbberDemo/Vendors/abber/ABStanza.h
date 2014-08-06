//
//  ABStanza.h
//  AbberDemo
//
//  Created by Kevin on 8/6/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>

@interface ABStanza : NSObject {
  xmpp_stanza_t *_cstanza;
}

@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *language;

+ (ABStanza *)stanzaWithObject:(xmpp_stanza_t *)stanza;

- (id)init;


- (NSString *)valueForAttribute:(NSString *)attr;
- (void)setValue:(NSString *)value forAttribute:(NSString *)attr;

@end
