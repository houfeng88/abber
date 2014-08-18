//
//  ABJid.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABJid.h"

@implementation ABJid

+ (ABJid *)jidWithString:(NSString *)string
{
  if ( [string length]<=0 ) {
    return nil;
  }
  
  NSString *node = nil;
  NSString *domain = nil;
  NSString *resource = nil;
  
  NSRange atRange = [domain rangeOfString:@"@"];
  
  if ( atRange.location!=NSNotFound ) {
    
    node = [string substringToIndex:atRange.location];
    NSString *minusNode = [string substringFromIndex:atRange.location+1];
    
    NSRange slashRange = [minusNode rangeOfString:@"/"];
    if ( slashRange.location!=NSNotFound ) {
      domain = [minusNode substringToIndex:slashRange.location];
      resource = [minusNode substringFromIndex:slashRange.location+1];
    } else {
      domain = minusNode;
    }
    
  } else {
    
    NSRange slashRange = [string rangeOfString:@"/"];
    if ( slashRange.location!=NSNotFound ) {
      domain = [string substringToIndex:slashRange.location];
      resource = [string substringFromIndex:slashRange.location+1];
    } else {
      domain = string;
    }
    
  }
  
  return [self jidWithNode:node domain:domain resource:resource];
}

+ (ABJid *)jidWithNode:(NSString *)node domain:(NSString *)domain resource:(NSString *)resource
{
  // non-empty string and nil will pass.
  if ( node && [node length]<=0 ) {
    return nil;
  }
  
  // the only required part of an jid.
  if ( (!domain) || ([domain length]<=0) ) {
    return nil;
  } else {
    // can not contains '@'.
    NSRange range = [domain rangeOfString:@"@"];
    if ( range.location!=NSNotFound ) {
      return nil;
    }
  }
  
  // non-empty string and nil will pass.
  if ( resource && [resource length]<=0 ) {
    return nil;
  }
  
  return [self jidWithPrevalidatedNode:node domain:domain resource:resource];
}

+ (ABJid *)jidWithPrevalidatedNode:(NSString *)node domain:(NSString *)domain resource:(NSString *)resource
{
  ABJid *jid = [[self alloc] init];
  jid->_node = [node copy];
  jid->_domain = [domain copy];
  jid->_resource = [resource copy];
  
  return jid;
}


- (ABJid *)bareJid
{
  if ( !_resource ) {
    return self;
  }
  return [ABJid jidWithPrevalidatedNode:_node domain:_domain resource:nil];
}


- (BOOL)isBareJid
{
  //          <domainpart> for a server
  // <nodepart@domainpart> for an account at a server
  return ( _resource==nil );
}

- (BOOL)isFullJid
{
  //          <domainpart/resourcepart>
  // <nodepart@domainpart/resourcepart>
  return ( _resource!=nil );
}


- (BOOL)isServerJid
{
  // <domainpart>
  // <domainpart/resourcepart>
  return ( _node==nil );
}


- (NSString *)stringValue
{
  NSMutableString *string = [[NSMutableString alloc] init];
  
  if ( _node ) {
    [string appendString:_node];
    [string appendString:@"@"];
  }
  
  [string appendString:_domain];
  
  if ( _resource ) {
    [string appendString:@"/"];
    [string appendString:_resource];
  }
  
  return string;
}


#pragma mark - NSObject

- (NSString *)description
{
  return [self stringValue];
}

- (BOOL)isEqual:(id)object
{
  if ( !object ) {
    return NO;
  }
  
  if ( ![object isKindOfClass:[self class]] ) {
    return NO;
  }
  
  ABJid *jid = object;
  
  if ( !(((!(self.node)) && (!(jid.node))) || [self.node isEqual:jid.node]) ) {
    return NO;
  }
  if ( !(((!(self.domain)) && (!(jid.domain))) || [self.domain isEqual:jid.domain]) ) {
    return NO;
  }
  if ( !(((!(self.resource)) && (!(jid.resource))) || [self.resource isEqual:jid.resource]) ) {
    return NO;
  }
  
  return YES;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    _node = [[coder decodeObjectForKey:@"kNode"] copy];
    _domain = [[coder decodeObjectForKey:@"kDomain"] copy];
    _resource = [[coder decodeObjectForKey:@"kResource"] copy];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:_node forKey:@"kNode"];
  [coder encodeObject:_domain forKey:@"kDomain"];
  [coder encodeObject:_resource forKey:@"kResource"];
}


#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

@end
