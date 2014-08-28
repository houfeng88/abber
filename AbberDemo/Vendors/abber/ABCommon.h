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


#define ABCSNonempty(a) (((a)!=NULL)&&(strlen(a)>0))
#define ABOSNonempty(a) (((a)!=nil )&&([(a) length]>0))

#define ABCStrOrLater(a,b) ((((a)!=NULL)&&(strlen(a)>0))?(a):(b))
#define ABOStrOrLater(a,b) ((((a)!=nil )&&([(a) length]>0))?(a):(b))


void ABConfigDatabase(NSString *jid);

NSString *ABMakeIdentifier(NSString *domain);
