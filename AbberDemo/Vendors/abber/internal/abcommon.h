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

#define AB_NONEMPTY(_val_) ((_val_!=NULL) && (strlen(_val_)>0))

#define AB_CSTR(_val_)    [_val_ UTF8String]
#define AB_OBJCSTR(_val_) [[NSString alloc] initWithUTF8String:_val_]



char *ab_create_jid_identifier(const char *prefix, const char *jid);

char *ab_create_rand_identifier(const char *prefix);

char *ab_create_merge_string(const char *prefix, const char *separator, const char *suffix);


void ab_md5_hash(char *dest, const char *source, size_t length);

#endif /* AB_COMMON_H */
