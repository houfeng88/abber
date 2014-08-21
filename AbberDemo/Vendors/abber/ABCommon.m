//
//  ABCommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABCommon.h"
#import <CommonCrypto/CommonDigest.h>

char *ABIdentifierCreate(const char *domain, const char *rand)
{
  char *identifier = NULL;
  
  if ( ABCSNonempty(domain) && ABCSNonempty(rand) ) {
    
    char suffix[33];
    memset(suffix, 0, 33);
    ABMD5Hash(suffix, rand, strlen(rand));
    
    size_t length = strlen(domain) + 1 + strlen(suffix) + 1;
    identifier = malloc(length);
    memset(identifier, 0, length);
    
    strcat(identifier, domain);
    strcat(identifier, "-");
    strcat(identifier, suffix);
  }
  
  return identifier;
}

int   ABIdentifierSeed()
{
  // 1000 ... 1999
  return arc4random() % 1000 + 1000;
}


void ABMD5Hash(char *dest, const char *source, size_t length)
{
  if ( !dest ) return;
  if ( !source ) return;
  if ( length<=0 ) return;
  
  unsigned char digest[CC_MD5_DIGEST_LENGTH];
  
  memset(digest, 0, CC_MD5_DIGEST_LENGTH);
  
  CC_MD5(source, length, digest);
  
  snprintf(dest, 33, "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
           digest[ 0], digest[ 1], digest[ 2], digest[ 3],
           digest[ 4], digest[ 5], digest[ 6], digest[ 7],
           digest[ 8], digest[ 9], digest[10], digest[11],
           digest[12], digest[13], digest[14], digest[15]);
}

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
