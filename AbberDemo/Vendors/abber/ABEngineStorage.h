//
//  ABEngineStorage.h
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (Storage)

// contact
- (NSArray *)contacts;
- (ABContact *)contactByJid:(NSString *)jid;
- (ABContact *)contactOrNewByJid:(NSString *)jid;

- (void)saveContact:(ABContact *)contact;
- (void)saveRoster:(NSArray *)roster;

- (void)deleteContactByJid:(NSString *)jid;

- (void)loadContacts;
- (void)syncContacts;


// session


// message

@end
