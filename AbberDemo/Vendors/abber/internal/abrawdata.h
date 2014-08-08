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

struct _ab_rawdata_t {
  const char *data;
  size_t length;
  struct _ab_rawdata_t *next;
};
typedef struct _ab_rawdata_t ab_rawdata_t;

typedef struct _ab_rawdata_t ** ab_rawdata_queue_t;


ab_rawdata_t *ab_enqueue(ab_rawdata_queue_t queue, ab_rawdata_t *rawdata);

ab_rawdata_t *ab_dequeue(ab_rawdata_queue_t queue);

void ab_destroy_queue(ab_rawdata_queue_t queue);


ab_rawdata_t *ab_create_rawdata(const char *data, const size_t length);

void ab_destroy_rawdata(ab_rawdata_t *rawdata);

#endif /* AB_RAWDATA_H */
