//
//  ABContactInfoViewController.h
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABContactInfoViewController : TKTableViewController {
  NSDictionary *_contact;
  
  UITextField *_memonameField;
}

- (id)initWithContact:(NSDictionary *)contact;

@end
