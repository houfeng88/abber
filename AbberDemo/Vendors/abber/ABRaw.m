//
//  ABRaw.m
//  AbberDemo
//
//  Created by Kevin Wu on 8/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "ABRaw.h"

ABRaw *ABRawQueueAdd(ABRaw **queue, ABRaw *raw)
{
  if ( raw ) {
    ABRaw *tail = *queue;
    
    if ( !tail ) {
      *queue = raw;
    } else {
      while ( tail->next ) {
        tail = tail->next;
      }
      tail->next = raw;
    }
  }
  
  return raw;
}

ABRaw *ABRawQueueRemove(ABRaw **queue)
{
  ABRaw *head = *queue;
  if ( head ) {
    *queue = head->next;
  }
  return head;
}

void   ABRawQueueDestroy(ABRaw **queue)
{
  ABRaw *head = *queue;
  while ( head ) {
    ABRaw *next = head->next;
    ABRawDestroy(head);
    head = next;
  }
  
  *queue = NULL;
}


ABRaw *ABRawCreate(const char *data, const size_t length)
{
  ABRaw *raw = NULL;
  
  if ( (data) && (length>0) ) {
    raw = malloc(sizeof(ABRaw));
    memset(raw, 0, sizeof(ABRaw));
    
    char *buffer = malloc(length+1);
    memset(buffer, 0, length+1);
    memcpy(buffer, data, length);
    raw->data = buffer;
    
    raw->length = length;
    
    raw->next = NULL;
  }
  
  return raw;
}

void   ABRawDestroy(ABRaw *raw)
{
  if ( raw ) {
    if ( raw->data ) {
      free((void *)(raw->data));
    }
    free(raw);
  }
}
