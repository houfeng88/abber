//
//  abcommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "abcommon.h"
#import <CommonCrypto/CommonDigest.h>

char *ab_create_identifier(const char *prefix, const char *jid)
{
  char *identifier = NULL;
  
  if ( (prefix) && (strlen(prefix)>0) ) {
    
    char suffix[CC_MD5_DIGEST_LENGTH*2+1];
    memset(suffix, 0, CC_MD5_DIGEST_LENGTH*2+1);
    
    if ( (jid) && (strlen(jid)>0) ) {
      unsigned char digest[CC_MD5_DIGEST_LENGTH];
      memset(digest, 0, CC_MD5_DIGEST_LENGTH);
      CC_MD5(jid, strlen(jid), digest);
      snprintf(suffix, 33, "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
               digest[ 0], digest[ 1], digest[ 2], digest[ 3],
               digest[ 4], digest[ 5], digest[ 6], digest[ 7],
               digest[ 8], digest[ 9], digest[10], digest[11],
               digest[12], digest[13], digest[14], digest[15]);
    }
    
    size_t length = strlen(prefix) + 1 + strlen(suffix) + 1;
    
    identifier = malloc(length);
    memset(identifier, 0, length);
    
    strcat(identifier, prefix);
    
    if ( strlen(suffix)>0 ) {
      strcat(identifier, "-");
      strcat(identifier, suffix);
    }
  }
  
  return identifier;
}
