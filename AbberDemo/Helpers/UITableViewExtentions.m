//
//  UITableViewExtentions.m
//  RefreshDemo
//
//  Created by Kevin Wu on 7/17/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UITableViewExtentions.h"

@implementation UITableView (Extentions)

- (void)updateTableWithNewRowCount:(NSUInteger)rowCount
{
  CGPoint offset = [self contentOffset];
  
  [UIView setAnimationsEnabled:NO];
  [self beginUpdates];
  
  CGFloat newHeight = 0.0;
  NSMutableArray *newRows = [[NSMutableArray alloc] init];
  
  for ( NSUInteger i=0; i<rowCount; ++i ) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    
    newHeight += [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    [newRows addObject:indexPath];
  }
  
  [self insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationNone];
  
  CGFloat newContentHeight = self.contentSize.height + newHeight;
  CGFloat maxOffsetY = MAX((newContentHeight-self.height), 0.0);
  CGFloat offsetY = offset.y + newHeight;
  offset.y = MIN(offsetY, maxOffsetY);
  
  [self endUpdates];
  [UIView setAnimationsEnabled:YES];
  
  [self setContentOffset:offset animated:NO];
}

@end
