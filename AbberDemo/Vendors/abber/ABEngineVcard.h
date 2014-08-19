//
//  ABEngineVcard.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"
#import "ABCommon.h"

@interface ABEngine (Vcard)

- (void)requestVcard:(NSString *)jid completion:(ABEngineRequestCompletionHandler)handler;

- (void)updateVcardWithNickname:(NSString *)nickname
                         avatar:(NSData *)avatar
                           desc:(NSDictionary *)desc
                     completion:(ABEngineRequestCompletionHandler)handler;

@end
