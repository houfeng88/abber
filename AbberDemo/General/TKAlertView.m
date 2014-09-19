//
//  TKAlertView.m
//  TapKit
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 Tapmob. All rights reserved.
//

#import "TKAlertView.h"

@implementation TKAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
  self = [super initWithTitle:title
                      message:message
                     delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil];
  if ( self ) {
    
    self.delegate = self;
    
    _blockMap = [[NSMutableDictionary alloc] init];
    
  }
  return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(TKAlertViewBlock)block
{
  if ( TKSNonempty(title) ) {
    
    if ( ![_blockMap hasKeyEqualTo:title] ) {
      NSInteger index = [self addButtonWithTitle:title];
      
      if ( block ) {
        [_blockMap setObject:[block copy] forKey:title];
      } else {
        [_blockMap setObject:[NSNull null] forKey:title];
      }
      
      return index;
    }
    
  }
  
  return -1;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(TKAlertViewBlock)block
{
  NSInteger index = [self addButtonWithTitle:title block:block];
  if ( index>=0 ) {
    [self setCancelButtonIndex:index];
  }
  return index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *title = [self buttonTitleAtIndex:buttonIndex];
  id block = [_blockMap objectForKey:title];
  if ( block!=[NSNull null] ) {
    ((TKAlertViewBlock)block)();
  }
}

@end
