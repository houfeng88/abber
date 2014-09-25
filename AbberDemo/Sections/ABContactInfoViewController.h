//
//  ABContactInfoViewController.h
//  AbberDemo
//
//  Created by Kevin on 9/5/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABContactInfoViewController : TKTableViewController {
  UITextField *_memonameField;
  
  ABContact *_contact;
}

- (id)initWithContact:(ABContact *)contact;

@end
