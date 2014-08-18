//
//  ABRaw.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

struct _ABRaw {
  const char *data;
  size_t length;
  struct _ABRaw *next;
};
typedef struct _ABRaw ABRaw;


ABRaw *ABRawQueueAdd(ABRaw **queue, ABRaw *raw);

ABRaw *ABRawQueueRemove(ABRaw **queue);

void   ABRawQueueDestroy(ABRaw **queue);


ABRaw *ABRawCreate(const char *data, const size_t length);

void   ABRawDestroy(ABRaw *raw);
