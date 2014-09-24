//
//  ABContact.m
//  AbberDemo
//
//  Created by Kevin on 9/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABContact.h"

@implementation ABContact

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    _jid = [aDecoder decodeObjectForKey:@"kJid"];
    _memoname = [aDecoder decodeObjectForKey:@"kMemoname"];
    _relation = [aDecoder decodeIntegerForKey:@"kRelation"];
    
    _nickname = [aDecoder decodeObjectForKey:@"kNickname"];
    _desc = [aDecoder decodeObjectForKey:@"kDesc"];
    
    
    //_status = [aDecoder decodeIntegerForKey:@"kStatus"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:_jid forKey:@"kJid"];
  [aCoder encodeObject:_memoname forKey:@"kMemoname"];
  [aCoder encodeInteger:_relation forKey:@"kRelation"];
  
  [aCoder encodeObject:_nickname forKey:@"kNickname"];
  [aCoder encodeObject:_desc forKey:@"kDesc"];
  
  
  //[aCoder encodeInteger:_status forKey:@"kStatus"];
}

@end
