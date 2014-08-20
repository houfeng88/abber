//
//  ABCommon.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <strophe/strophe.h>
#include <strophe/common.h>

#define ABCString(_s_) [(_s_) UTF8String]
#define ABOString(_s_) [[NSString alloc] initWithUTF8String:(_s_)]

#define ABCSNonempty(_s_) (((_s_)!=NULL) && (strlen(_s_)>0))
#define ABOSNonempty(_s_) (((_s_)!=nil) && ([(_s_) length]>0))

#define ABCStringOrLater(_s_) (((_s_)!=NULL)?(_s_):"")
#define ABOStringOrLater(_a_, _b_) (([(_a_) length]>0)?(_a_):(_b_))

#define ABCStringHasPrefix(_sa_,_sb_) (strncmp(_sa_, _sb_, strlen(_sb_))==0)

char *ABIdentifierCreate(const char *domain, const char *rand);

int   ABIdentifierSeed();


void ABMD5Hash(char *dest, const char *source, size_t length);

NSString *ABMakeIdentifier(NSString *domain);
