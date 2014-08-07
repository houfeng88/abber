//
//  abrawdata.h
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include <stdio.h>

#ifndef AB_RAWDATA_H
#define AB_RAWDATA_H

struct _rawdata_t {
  const char *data;
  size_t length;
  struct _rawdata_t *next;
};
typedef struct _rawdata_t rawdata_t;

typedef struct _rawdata_t ** rawdata_queue_t;


rawdata_t *ab_enqueue(rawdata_queue_t queue, rawdata_t *rawdata);

rawdata_t *ab_dequeue(rawdata_queue_t queue);

void ab_destroy_queue(rawdata_queue_t queue);


rawdata_t *ab_create_rawdata(const char *data, const size_t length);

void ab_destroy_rawdata(rawdata_t *rawdata);

#endif /* AB_RAWDATA_H */
