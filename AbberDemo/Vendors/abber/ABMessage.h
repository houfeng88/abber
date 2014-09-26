//
//  ABMessage.h
//  AbberDemo
//
//  Created by Kevin on 9/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ABMessageText   @"text"
#define ABMessageAudio  @"audio"
#define ABMessageImage  @"image"
#define ABMessageNudge  @"nudge"

@interface ABMessage : NSObject

@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) id body;

@end
