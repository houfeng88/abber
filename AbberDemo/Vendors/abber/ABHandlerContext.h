//
//  ABHandlerContext.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEngine.h"

@interface ABHandlerContext : NSObject {
  __weak ABEngine *_engine;
  
  ABEngineCompletionHandler _completionHandler;
  
  NSString *_identifier;
  xmpp_handler _handler;
}

@property (nonatomic, weak) ABEngine *engine;

@property (nonatomic, copy) ABEngineCompletionHandler completionHandler;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) xmpp_handler handler;

@end
