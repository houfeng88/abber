//
//  ABEngineDatabase.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/25/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABEngineDatabase.h"

@implementation ABEngine (Database)

- (TKDatabase *)database
{
//  if ( TKSNonempty(jid) ) {
//    NSString *path = TKPathForDocumentResource(jid);
//    TKCreateDirectory(path);
//    
//    NSString *dbpath = [path stringByAppendingPathComponent:@"im.db"];
//    TKDatabase *db = [[TKDatabase alloc] initWithPath:dbpath];
//    [TKDatabase saveObject:db];
//    
//    [db open];
//    
//    
//    if ( ![db hasTableNamed:@"contact"] ) {
//      NSString *contactSQL =
//      @"CREATE TABLE contact("
//      @"pk INTEGER PRIMARY KEY, "
//      @"jid TEXT, "
//      @"memoname TEXT, "
//      @"relation INTEGER);";
//      [db executeUpdate:contactSQL];
//    }
//  }
  return nil;
}

- (void)configDatabase
{
}

@end
