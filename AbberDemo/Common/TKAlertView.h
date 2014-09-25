//
//  TKAlertView.h
//  TapKit
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TKAlertViewBlock)(void);

@interface TKAlertView : UIAlertView<
    UIAlertViewDelegate
> {
  NSMutableDictionary *_blockMap;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (NSInteger)addButtonWithTitle:(NSString *)title block:(TKAlertViewBlock)block;
- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(TKAlertViewBlock)block;

@end
