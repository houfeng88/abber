//
//  ABEngineDatabase.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/25/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"
#import "ABCommon.h"

@interface ABEngine (Database)

- (TKDatabase *)database;

- (void)configDatabase;

@end
