//
//  abcommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "abcommon.h"
#import <CommonCrypto/CommonDigest.h>

char *ab_identifier_create(const char *domain, const char *rand)
{
  char *identifier = NULL;
  
  if ( ABCNonempty(domain) && ABCNonempty(rand) ) {
    
    char suffix[33];
    memset(suffix, 0, 33);
    ab_md5_hash(suffix, rand, strlen(rand));
    
    identifier = malloc(strlen(domain)+1+strlen(suffix)+1);
    strcat(identifier, domain);
    strcat(identifier, "-");
    strcat(identifier, suffix);
  }
  
  return identifier;
}

int ab_identifier_seed()
{
  // 1000 ... 1999
  return arc4random() % 1000 + 1000;
}


void ab_md5_hash(char *dest, const char *source, size_t length)
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
