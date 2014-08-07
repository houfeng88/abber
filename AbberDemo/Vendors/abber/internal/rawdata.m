//
//  rawdata.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "rawdata.h"
#include <stdlib.h>
#include <string.h>

rawdata_t *ab_enqueue(rawdata_queue_t queue, rawdata_t *rawdata)
{
  if ( rawdata ) {
    rawdata_t *tail = *queue;
    
    if ( !tail ) {
      *queue = rawdata;
    } else {
      while ( tail->next ) {
        tail = tail->next;
      }
      tail->next = rawdata;
    }
  }
  
  return rawdata;
}

rawdata_t *ab_dequeue(rawdata_queue_t queue)
{
  rawdata_t *head = *queue;
  if ( head ) {
    *queue = head->next;
  }
  return head;
}


rawdata_t *ab_create_rawdata(const char *data, const size_t len)
{
  rawdata_t *rawdata = NULL;
  
  if ( (data) && (len>0) ) {
    rawdata = malloc(sizeof(rawdata_t));
    memset(rawdata, 0, sizeof(rawdata_t));
    
    rawdata->data = data;
    rawdata->len = len;
    rawdata->next = NULL;
  }
  
  return rawdata;
}

void ab_destroy_rawdata(rawdata_t *rawdata)
{
  free(rawdata);
}
