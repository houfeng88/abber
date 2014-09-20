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
  if ( TKSNonempty(path) ) {
    _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    
    NSString *contactSQL =
    @"CREATE TABLE IF NOT EXISTS contact("
    @"pk INTEGER PRIMARY KEY, "
    @"jid TEXT, "
    @"status INTEGER, "
    @"memoname TEXT, "
    @"relation INTEGER, "
    @"nickname TEXT, "
    @"desc TEXT);";
    [_databaseQueue inDatabase:^(FMDatabase *db) { [db executeUpdate:contactSQL]; }];
  }
}



- (NSArray *)contacts
{
  NSMutableArray *contactAry = [[NSMutableArray alloc] init];
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM contact;"];
    while ( [rs next] ) {
      NSString *jid = [rs stringForColumn:@"jid"];
      int status = [rs intForColumn:@"status"];
      NSString *memoname = [rs stringForColumn:@"memoname"];
      int relation = [rs intForColumn:@"relation"];
      NSString *nickname = [rs stringForColumn:@"nickname"];
      NSString *desc = [rs stringForColumn:@"desc"];
      
      NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
      [contact setObject:jid forKeyIfNotNil:@"jid"];
      [contact setObject:@(status) forKeyIfNotNil:@"status"];
      [contact setObject:memoname forKeyIfNotNil:@"memoname"];
      [contact setObject:@(relation) forKeyIfNotNil:@"relation"];
      [contact setObject:nickname forKeyIfNotNil:@"nickname"];
      [contact setObject:desc forKeyIfNotNil:@"desc"];
      [contactAry addObject:contact];
    }
    [rs close];
  }];
  return TKAryOrLater(contactAry, nil);
}

- (NSDictionary *)contactByJid:(NSString *)jid
{
  if ( TKSNonempty(jid) ) {
    NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
      FMResultSet *rs = [db executeQuery:@"SELECT * FROM contact WHERE jid=?;", jid];
      while ( [rs next] ) {
        NSString *jid = [rs stringForColumn:@"jid"];
        int status = [rs intForColumn:@"status"];
        NSString *memoname = [rs stringForColumn:@"memoname"];
        int relation = [rs intForColumn:@"relation"];
        NSString *nickname = [rs stringForColumn:@"nickname"];
        NSString *desc = [rs stringForColumn:@"desc"];
        
        [contact setObject:jid forKeyIfNotNil:@"jid"];
        [contact setObject:@(status) forKeyIfNotNil:@"status"];
        [contact setObject:memoname forKeyIfNotNil:@"memoname"];
        [contact setObject:@(relation) forKeyIfNotNil:@"relation"];
        [contact setObject:nickname forKeyIfNotNil:@"nickname"];
        [contact setObject:desc forKeyIfNotNil:@"desc"];
      }
      [rs close];
    }];
    return TKMapOrLater(contact, nil);
  }
  return nil;
}


- (void)saveRoster:(NSArray *)roster
{
  NSArray *jidAry = [roster valueForKeyPath:@"@unionOfObjects.jid"];
  
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    FMResultSet *rs = [db executeQuery:@"SELECT jid FROM contact;"];
    while ( [rs next] ) {
      NSString *jid = [rs stringForColumn:@"jid"];
      if ( ![jidAry containsObject:jid] ) {
        [db executeUpdate:@"DELETE FROM contact WHERE jid=?;", jid];
      }
    }
    [rs close];
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
      [db executeUpdate:@"INSERT INTO contact(memoname, relation, jid) VALUES(?, ?, ?);", memoname, relation, jid];
    }
    [rs close];
  }];
}

- (void)deleteContact:(NSDictionary *)contact
{
  NSString *jid = [contact objectForKey:@"jid"];
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"DELETE FROM contact WHERE jid=?;", jid];
  }];
}


- (void)savePresence:(int)presence contact:(NSString *)jid
{
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"UPDATE contact SET status=? WHERE jid=?;", @(presence), jid];
  }];
}

- (void)clearAllPresence
{
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"UPDATE contact SET status=?;", @(ABPresenceTypeUnavailable)];
  }];
}


- (void)saveVcard:(NSDictionary *)vcard
{
  NSString *jid = [vcard objectForKey:@"jid"];
  NSString *nickname = [vcard objectForKey:@"nickname"];
  NSString *desc = [vcard objectForKey:@"desc"];
  [_databaseQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"UPDATE contact SET nickname=?, desc=? WHERE jid=?;", nickname, desc, jid];
  }];
}

@end
