//
//  ABCommon.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABCommon.h"

void ABConfigDatabase(NSString *jid)
{
  if ( TKSNonempty(jid) ) {
    NSString *path = TKPathForDocumentResource(jid);
    TKCreateDirectory(path);
    
    NSString *dbpath = [path stringByAppendingPathComponent:@"im.db"];
    TKDatabase *db = [[TKDatabase alloc] initWithPath:dbpath];
    [TKDatabase saveObject:db];
    
    [db open];
    
    
    if ( ![db hasTableNamed:@"contact"] ) {
      NSString *contactSQL =
      @"CREATE TABLE contact("
      @"pk INTEGER PRIMARY KEY, "
      @"jid TEXT, "
      @"memoname TEXT, "
      @"relation INTEGER);";
      [db executeUpdate:contactSQL];
    }
  }
}

NSString *ABMakeIdentifier(NSString *domain)
{
  NSString *identifier = nil;
  if ( ABOSNonempty(domain) ) {
    identifier = [[NSMutableString alloc] init];
    
    [(NSMutableString *)identifier appendString:domain];
    
    [(NSMutableString *)identifier appendString:@"-"];
    
    [(NSMutableString *)identifier appendString:[[NSUUID UUID] UUIDString]];
  }
  return identifier;
}
