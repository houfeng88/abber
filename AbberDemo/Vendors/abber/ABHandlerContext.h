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
  NSString *_jid;
  ABEngineCompletionHandler _completion;
  
  NSString *_identifier;
  xmpp_handler _handler;
  
  id _info;
}

@property (nonatomic, weak) ABEngine *engine;
@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) ABEngineCompletionHandler completion;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) xmpp_handler handler;

@property (nonatomic, strong) id info;

@end
