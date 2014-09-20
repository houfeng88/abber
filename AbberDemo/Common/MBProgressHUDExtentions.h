//
//  MBProgressHUDExtentions.h
//  HudDemo
//
//  Created by Kevin Wu on 7/28/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extentions)

+ (MBProgressHUD *)presentProgressHUD:(UIView *)boxView
                                 info:(NSString *)info
                              offsetY:(CGFloat)offsetY;

+ (MBProgressHUD *)presentProgressHUD:(UIView *)boxView
                                 info:(NSString *)info
                              offsetY:(CGFloat)offsetY
                     createIfNonexist:(BOOL)createIfNonexist
                      completionBlock:(MBProgressHUDCompletionBlock)completionBlock;


+ (MBProgressHUD *)presentTextHUD:(UIView *)boxView
                             info:(NSString *)info
                          offsetY:(CGFloat)offsetY
                  completionBlock:(MBProgressHUDCompletionBlock)completionBlock;


+ (void)dismissHUD:(UIView *)boxView
       immediately:(BOOL)immediately
   completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

@end
