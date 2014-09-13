//
//  ABEngineStorage.m
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineStorage.h"

@implementation ABEngine (Storage)

- (FMDatabaseQueue *)databaseQueue
{
  return _databaseQueue;
}

- (void)createDatabaseQueue:(NSString *)path
{
  _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:path];
  
  NSString *contactSQL =
  @"CREATE TABLE IF NOT EXISTS contact("
  @"pk INTEGER PRIMARY KEY, "
  @"jid TEXT, "
  @"memoname TEXT, "
  @"relation INTEGER, "
  @"nickname TEXT, "
  @"desc TEXT);";
  [_databaseQueue inDatabase:^(FMDatabase *db) { [db executeUpdate:contactSQL]; }];
}


- (NSArray *)loadContacts
{
  NSMutableArray *contactAry = [[NSMutableArray alloc] init];
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM contact;"];
    while ( [rs next] ) {
      NSString *jid = [rs stringForColumn:@"jid"];
      NSString *memoname = [rs stringForColumn:@"memoname"];
      int relation = [rs intForColumn:@"relation"];
      NSString *nickname = [rs stringForColumn:@"nickname"];
      NSString *avatar = [rs stringForColumn:@"avatar"];
      NSString *birthday = [rs stringForColumn:@"birthday"];
      NSString *desc = [rs stringForColumn:@"desc"];
      
      NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
      [contact setObject:jid forKeyIfNotNil:@"jid"];
      [contact setObject:memoname forKeyIfNotNil:@"memoname"];
      [contact setObject:@(relation) forKeyIfNotNil:@"relation"];
      [contact setObject:nickname forKeyIfNotNil:@"nickname"];
      [contact setObject:avatar forKeyIfNotNil:@"avatar"];
      [contact setObject:birthday forKeyIfNotNil:@"birthday"];
      [contact setObject:desc forKeyIfNotNil:@"desc"];
      [contactAry addObject:contact];
    }
  }];
  return TKAryOrLater(contactAry, nil);
}

- (void)saveRoster:(NSArray *)roster
{
  NSArray *jidAry = [roster valueForKeyPath:@"@unionOfObjects.jid"];
  
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM contact;"];
    while ( [rs next] ) {
      NSString *jid = [rs stringForColumn:@"jid"];
      if ( ![jidAry containsObject:jid] ) {
        [db executeUpdate:@"DELETE FROM contact WHERE jid=?;", jid];
      }
    }
  }];
  
  for ( NSDictionary *contact in roster ) {
    [self saveContact:contact];
  }
}

- (void)saveContact:(NSDictionary *)contact
{
  NSString *jid = [contact objectForKey:@"jid"];
  NSString *memoname = [contact objectForKey:@"memoname"];
  NSNumber *relation = [contact objectForKey:@"relation"];
  
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    FMResultSet *rs = [db executeQuery:@"SELECT count(*) AS count FROM contact WHERE jid=?;", jid];
    if ( [rs next] && ([rs intForColumn:@"count"]>0) ) {
      [db executeUpdate:@"UPDATE contact SET memoname=?, relation=? WHERE jid=?;", memoname, relation, jid];
    } else {
      [db executeUpdate:@"INSERT INTO contact(jid, memoname, relation) VALUES(?, ?, ?);", jid, memoname, relation];
    }
  }];
}

- (void)deleteContact:(NSDictionary *)contact
{
  NSString *jid = [contact objectForKey:@"jid"];
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"DELETE FROM contact WHERE jid=?;", jid];
  }];
}

@end
