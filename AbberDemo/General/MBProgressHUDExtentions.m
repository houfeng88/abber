//
//  MBProgressHUDExtentions.m
//  HudDemo
//
//  Created by Kevin Wu on 7/28/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "MBProgressHUDExtentions.h"

@implementation MBProgressHUD (Extentions)

+ (MBProgressHUD *)presentProgressHUD:(UIView *)boxView
                                 info:(NSString *)info
                              offsetY:(CGFloat)offsetY
{
  MBProgressHUD *hud = [MBProgressHUD HUDForView:boxView];
  
  if ( !hud ) {
    hud = [[MBProgressHUD alloc] initWithView:boxView];
    [boxView addSubview:hud];
  } else {
    if ( hud.mode!=MBProgressHUDModeIndeterminate ) {
      [hud removeFromSuperview];
      hud = [[MBProgressHUD alloc] initWithView:boxView];
      [boxView addSubview:hud];
    }
  }
  
  hud.labelText = info;
  hud.labelFont = [UIFont boldSystemFontOfSize:15.0];
  
  hud.mode = MBProgressHUDModeIndeterminate;
  hud.animationType = MBProgressHUDAnimationFade;
  hud.removeFromSuperViewOnHide = YES;
  hud.square = YES;
  hud.dimBackground = NO;
  hud.taskInProgress = YES;
  hud.graceTime = 0.0;
  hud.minShowTime = 1.0;
  
  hud.color = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.9];
  hud.yOffset = offsetY;
  
  [hud show:YES];
  
  return hud;
}

+ (MBProgressHUD *)presentProgressHUD:(UIView *)boxView
                                 info:(NSString *)info
                              offsetY:(CGFloat)offsetY
                     createIfNonexist:(BOOL)createIfNonexist
                      completionBlock:(MBProgressHUDCompletionBlock)completionBlock
{
  MBProgressHUD *hud = [MBProgressHUD HUDForView:boxView];
  
  if ( !hud ) {
    if ( createIfNonexist ) {
      hud = [[MBProgressHUD alloc] initWithView:boxView];
      [boxView addSubview:hud];
    } else {
      return nil;
    }
  } else {
    if ( hud.mode!=MBProgressHUDModeIndeterminate ) {
      [hud removeFromSuperview];
      hud = [[MBProgressHUD alloc] initWithView:boxView];
      [boxView addSubview:hud];
    }
  }
  
  hud.labelText = info;
  hud.labelFont = [UIFont boldSystemFontOfSize:15.0];
  
  hud.mode = MBProgressHUDModeIndeterminate;
  hud.animationType = MBProgressHUDAnimationFade;
  hud.removeFromSuperViewOnHide = YES;
  hud.square = YES;
  hud.dimBackground = NO;
  hud.taskInProgress = YES;
  hud.graceTime = 0.0;
  hud.minShowTime = 1.0;
  
  hud.color = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.9];
  hud.yOffset = offsetY;
  
  [hud show:YES];
  
  hud.completionBlock = completionBlock;
  [hud hide:YES afterDelay:1.0];
  
  return hud;
}


+ (MBProgressHUD *)presentTextHUD:(UIView *)boxView
                             info:(NSString *)info
                          offsetY:(CGFloat)offsetY
                  completionBlock:(MBProgressHUDCompletionBlock)completionBlock
{
  MBProgressHUD *hud = [MBProgressHUD HUDForView:boxView];
  
  if ( !hud ) {
    hud = [[MBProgressHUD alloc] initWithView:boxView];
    [boxView addSubview:hud];
  } else {
    if ( hud.mode!=MBProgressHUDModeText ) {
      [hud removeFromSuperview];
      hud = [[MBProgressHUD alloc] initWithView:boxView];
      [boxView addSubview:hud];
    }
  }
  
  hud.detailsLabelText = info;
  
  hud.mode = MBProgressHUDModeText;
  hud.animationType = MBProgressHUDAnimationFade;
  hud.removeFromSuperViewOnHide = YES;
  hud.square = NO;
  hud.dimBackground = NO;
  hud.taskInProgress = YES;
  hud.graceTime = 0.0;
  hud.minShowTime = 2.0;
  
  hud.color = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.9];
  
  [hud show:YES];
  
  hud.completionBlock = completionBlock;
  [hud hide:YES afterDelay:2.0];
  
  return hud;
}


+ (void)dismissHUD:(UIView *)boxView
       immediately:(BOOL)immediately
   completionBlock:(MBProgressHUDCompletionBlock)completionBlock
{
  MBProgressHUD *hud = [MBProgressHUD HUDForView:boxView];
  if ( immediately ) {
    [hud removeFromSuperview];
    if ( completionBlock ) {
      completionBlock();
    }
  } else {
    hud.completionBlock = completionBlock;
    [hud hide:YES];
  }
}

@end
