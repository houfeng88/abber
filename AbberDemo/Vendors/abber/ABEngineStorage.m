//
//  ABEngineStorage.m
//  AbberDemo
//
//  Created by Kevin on 9/13/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineStorage.h"

@implementation ABEngine (Storage)

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
      }
    }
  }
}


- (void)loadContacts
{
  NSString *root = TKPathForDocumentResource([self bareJid]);
  NSString *path = [root stringByAppendingPathComponent:@"contact.db"];
  
  NSData *data = [[NSData alloc] initWithContentsOfFile:path];
  NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  
  _contactAry = [[NSMutableArray alloc] init];
  [_contactAry addObjectsFromArray:ary];
}

- (void)syncContacts
{
  NSString *root = TKPathForDocumentResource([self bareJid]);
  NSString *path = [root stringByAppendingPathComponent:@"contact.db"];
  
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contactAry];
  [data writeToFile:path atomically:YES];
}

@end
