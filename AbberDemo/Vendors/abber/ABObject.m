//
//  ABObject.m
//  AbberDemo
//
//  Created by Kevin on 8/9/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABObject.h"

@implementation ABObject

- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"[obj] init ...");
  }
  return self;
}

- (void)dealloc
{
  NSLog(@"[obj] dealloc ...");
}

- (NSString *)description
{
  return @"an object";
}

@end
