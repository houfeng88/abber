//
//  ABEngineRoster.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABEngine (Roster)

- (void)requestRosterWithCompletion:(ABEngineRequestCompletionHandler)handler;

@end
