//
//  ABSessionViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 9/29/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABSessionViewController : TKTableViewController {
  NSDictionary *_context;
}

- (id)initWithContext:(NSDictionary *)context;

@end
