//
//  abrawdata.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/7/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#include "abrawdata.h"
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

void ab_destroy_queue(rawdata_queue_t queue)
{
  rawdata_t *head = *queue;
  while ( head ) {
    rawdata_t *next = head->next;
    ab_destroy_rawdata(head);
    head = next;
  }
  
  *queue = NULL;
}


rawdata_t *ab_create_rawdata(const char *data, const size_t length)
{
  rawdata_t *rawdata = NULL;
  
  if ( (data) && (length>0) ) {
    rawdata = malloc(sizeof(rawdata_t));
    memset(rawdata, 0, sizeof(rawdata_t));
    
    char *buffer = malloc(length+1);
    memset(buffer, 0, length+1);
    memcpy(buffer, data, length);
    rawdata->data = buffer;
    
    rawdata->length = length;
    
    rawdata->next = NULL;
  }
  
  return rawdata;
}

void ab_destroy_rawdata(rawdata_t *rawdata)
{
  if ( rawdata ) {
    if ( rawdata->data ) {
      free((void *)(rawdata->data));
    }
    free(rawdata);
  }
}
