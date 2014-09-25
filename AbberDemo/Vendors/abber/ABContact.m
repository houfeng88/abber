//
//  ABContact.m
//  AbberDemo
//
//  Created by Kevin on 9/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABContact.h"

@implementation ABContact

- (id)init
{
  self = [super init];
  if (self) {
    _status = @"Unavailable";
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    _jid = [aDecoder decodeObjectForKey:@"kJid"];
    _memoname = [aDecoder decodeObjectForKey:@"kMemoname"];
    _ask = [aDecoder decodeObjectForKey:@"kAsk"];
    _subscription = [aDecoder decodeObjectForKey:@"kSubscription"];
    
    _nickname = [aDecoder decodeObjectForKey:@"kNickname"];
    _desc = [aDecoder decodeObjectForKey:@"kDesc"];
    
    _status = @"Unavailable";
    //_status = [aDecoder decodeObjectForKey:@"kStatus"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:_jid forKey:@"kJid"];
  [aCoder encodeObject:_memoname forKey:@"kMemoname"];
  [aCoder encodeObject:_ask forKey:@"kAsk"];
  [aCoder encodeObject:_subscription forKey:@"kSubscription"];
  
  [aCoder encodeObject:_nickname forKey:@"kNickname"];
  [aCoder encodeObject:_desc forKey:@"kDesc"];
  
  
  //[aCoder encodeObject:_status forKey:@"kStatus"];
}

@end
