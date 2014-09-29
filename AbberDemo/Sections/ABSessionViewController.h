//
//  ABSessionViewController.h
//  AbberDemo
//
//  Created by Kevin Wu on 9/29/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABSessionViewController : TKTableViewController {
  ABContact *_contact;
}

- (id)initWithContact:(ABContact *)contact;

@end
