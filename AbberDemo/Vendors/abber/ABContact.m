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
    _status = @"unavailable";
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self) {
    _jid = [coder decodeObjectForKey:@"kJid"];
    _memoname = [coder decodeObjectForKey:@"kMemoname"];
    _ask = [coder decodeObjectForKey:@"kAsk"];
    _subscription = [coder decodeObjectForKey:@"kSubscription"];
    
    _nickname = [coder decodeObjectForKey:@"kNickname"];
    _desc = [coder decodeObjectForKey:@"kDesc"];
    
    
    _status = @"unavailable";
    //_status = [coder decodeObjectForKey:@"kStatus"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:_jid forKey:@"kJid"];
  [coder encodeObject:_memoname forKey:@"kMemoname"];
  [coder encodeObject:_ask forKey:@"kAsk"];
  [coder encodeObject:_subscription forKey:@"kSubscription"];
  
  [coder encodeObject:_nickname forKey:@"kNickname"];
  [coder encodeObject:_desc forKey:@"kDesc"];
  
  
  //[coder encodeObject:_status forKey:@"kStatus"];
}

@end
