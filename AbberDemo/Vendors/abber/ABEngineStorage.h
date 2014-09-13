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

- (FMDatabaseQueue *)databaseQueue;
- (void)createDatabaseQueue:(NSString *)path;

- (NSArray *)loadContacts;
- (void)saveRoster:(NSArray *)roster;
- (void)saveContact:(NSDictionary *)contact;
- (void)deleteContact:(NSDictionary *)contact;

@end