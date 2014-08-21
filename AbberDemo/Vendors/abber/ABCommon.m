//
//  ABCommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABCommon.h"

NSString *ABMakeIdentifier(NSString *domain)
{
  NSString *identifier = nil;
  if ( ABOSNonempty(domain) ) {
    identifier = [[NSMutableString alloc] init];
    
    [(NSMutableString *)identifier appendString:domain];
    
    [(NSMutableString *)identifier appendString:@"-"];
    
    [(NSMutableString *)identifier appendString:[NSString UUIDString]];
  }
  return identifier;
}
