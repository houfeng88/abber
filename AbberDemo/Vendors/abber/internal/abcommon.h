//
//  abcommon.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include <strophe/strophe.h>

#ifndef AB_COMMON_H
#define AB_COMMON_H

#define ABCNonempty(_s_) (((_s_)!=NULL) && (strlen(_s_)>0))

#define ABCStringOrLater(_s_) (((_s_)!=NULL)?(_s_):"")
#define ABOStringOrLater(_a_, _b_) (([(_a_) length]>0)?(_a_):(_b_))

#define ABCString(_s_) [(_s_) UTF8String]
#define ABOString(_s_) [[NSString alloc] initWithUTF8String:(_s_)]


char *ab_identifier_create(const char *domain, const char *rand);

int ab_identifier_seed();


void ab_md5_hash(char *dest, const char *source, size_t length);

#endif /* AB_COMMON_H */
