//
//  abcommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "abcommon.h"
#import <CommonCrypto/CommonDigest.h>

char *ab_create_jid_identifier(const char *prefix, const char *jid)
{
  char *identifier = NULL;
  
  if ( AB_NONEMPTY(prefix) ) {
    
    char suffix[33];
    memset(suffix, 0, 33);
    if ( AB_NONEMPTY(jid) ) {
      ab_md5_hash(suffix, jid, strlen(jid));
    }
    
    identifier = ab_create_merge_string(prefix, "-", suffix);
  }
  
  return identifier;
}

char *ab_create_rand_identifier(const char *prefix)
{
  char *identifier = NULL;
  
  if ( AB_NONEMPTY(prefix) ) {
    
    char suffix[10];
    memset(suffix, 0, 10);
    
    int rand = arc4random() % 1000 + 1000; // 1000 ... 1999
    snprintf(suffix, 10, "%d", rand);
    
    identifier = ab_create_merge_string(prefix, "-", suffix);
  }
  
  return identifier;
}

char *ab_create_merge_string(const char *prefix, const char *separator, const char *suffix)
{
  char *string = NULL;
  
  size_t length = 0;
  if ( AB_NONEMPTY(prefix) ) length += strlen(prefix);
  if ( AB_NONEMPTY(suffix) ) length += strlen(suffix);
  
  if ( length>0 ) {
    if ( AB_NONEMPTY(separator) ) {
      length += strlen(separator);
    }
    length += 1; // trail '\0'
    
    string = malloc(length);
    memset(string, 0, length);
    
    if ( AB_NONEMPTY(prefix) ) {
      strcat(string, prefix);
      if ( AB_NONEMPTY(suffix) ) {
        if ( AB_NONEMPTY(separator) ) {
          strcat(string, separator);
        }
        strcat(string, suffix);
      } else {
        // ...
      }
    } else {
      // ...
      if ( AB_NONEMPTY(suffix) ) {
        strcat(string, suffix);
      } else {
        // ...
      }
    }
    
  }
  
  return string;
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
