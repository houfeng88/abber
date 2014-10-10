//
//  ABContact.h
//  AbberDemo
//
//  Created by Kevin on 9/24/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABContact : NSObject<
    NSCoding
> {
}

@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) NSString *memoname;
@property (nonatomic, copy) NSString *ask;
@property (nonatomic, copy) NSString *subscription;

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *desc;


@property (nonatomic, copy) NSString *status;

@end
