//
//  ABEngineVcard.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (Vcard)

- (void)requestVcard:(NSString *)jid completion:(ABEngineCompletionHandler)completion;
- (void)updateVcardWithNickname:(NSString *)nickname desc:(NSString *)desc completion:(ABEngineCompletionHandler)completion;

@end


@protocol ABEngineVcardDelegate <NSObject>
@optional

- (void)engine:(ABEngine *)engine didReceiveVcard:(NSDictionary *)vcard error:(NSError *)error;
- (void)engine:(ABEngine *)engine didCompleteUpdateVcard:(NSString *)jid error:(NSError *)error;

@end