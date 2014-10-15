//
//  ABEngineStorage.m
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineStorage.h"

@implementation ABEngine (Storage)

#pragma mark - Path

- (NSString *)storagePath
{
  return TKPathForDocumentResource([self bareJid]);
}



#pragma mark - user

- (ABContact *)user
{
  return _user;
}


- (void)loadUser
{
  NSString *path = [[self storagePath] stringByAppendingPathComponent:@"user.db"];

  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  ABContact *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

  if ( !user ) {
    user = [[ABContact alloc] init];
    user.jid = [self bareJid];
  }

  _user = user;
}

- (void)syncUser
{
  NSString *path = [[self storagePath] stringByAppendingPathComponent:@"user.db"];

  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_user];
  [data writeToFile:path atomically:YES];
}



#pragma mark - contact

- (NSArray *)contacts
{
  return _contactAry;
}

- (ABContact *)contactByJid:(NSString *)jid
{
  if ( TKSNonempty(jid) ) {
    for ( ABContact *it in _contactAry ) {
      if ( [jid isEqualToString:it.jid] ) {
        return it;
      }
    }
  }
  return nil;
}

- (ABContact *)contactOrNewByJid:(NSString *)jid
{
  ABContact *contact = [self contactByJid:jid];
  if ( !contact ) {
    contact = [[ABContact alloc] init];
    contact.jid = jid;
  }
  return contact;
}


- (void)saveContact:(ABContact *)contact
{
  NSString *jid = contact.jid;
  if ( TKSNonempty(jid) ) {
    [self deleteContactByJid:jid];
    [_contactAry addObject:contact];
  }
}

- (void)saveRoster:(NSArray *)roster
{
  [_contactAry removeAllObjects];
  [_contactAry addObjectsFromArray:roster];
}


- (void)deleteContactByJid:(NSString *)jid
{
  if ( TKSNonempty(jid) ) {
    for ( NSUInteger i=0; i<[_contactAry count]; ++i ) {
      ABContact *it = [_contactAry objectAtIndex:i];
      if ( [jid isEqualToString:it.jid] ) {
        [_contactAry removeObjectAtIndex:i];
        return;
      }
    }
  }
}


- (void)loadContacts
{
  NSString *path = [[self storagePath] stringByAppendingPathComponent:@"contacts.db"];
  
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  NSArray *contactAry = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  
  _contactAry = [[NSMutableArray alloc] init];
  [_contactAry addObjectsFromArray:contactAry];
}

- (void)syncContacts
{
  NSString *path = [[self storagePath] stringByAppendingPathComponent:@"contacts.db"];
  
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contactAry];
  [data writeToFile:path atomically:YES];
}

@end
