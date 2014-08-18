//
//  ABJid.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>

@interface ABJid : NSObject<
    NSCoding,
    NSCopying
> {
  NSString *_node;
  NSString *_domain;
  NSString *_resource;
}

@property (nonatomic, copy, readonly) NSString *node;
@property (nonatomic, copy, readonly) NSString *domain;
@property (nonatomic, copy, readonly) NSString *resource;

+ (ABJid *)jidWithString:(NSString *)string;
+ (ABJid *)jidWithNode:(NSString *)node domain:(NSString *)domain resource:(NSString *)resource;
+ (ABJid *)jidWithPrevalidatedNode:(NSString *)node domain:(NSString *)domain resource:(NSString *)resource;

- (ABJid *)bareJid;

- (BOOL)isBareJid;
- (BOOL)isFullJid;

- (BOOL)isServerJid;

- (NSString *)stringValue;

@end
