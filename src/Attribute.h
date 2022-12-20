/*
 *  Attribute.h
 *
 *  Created by Janin on 10/2019
 *  Copyright 2018 LaBRI. All rights reserved.
 *
 *  Module for a clean handling of attibutes values
 *
 */

#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H

typedef enum {INT, TVOID} type;


struct ATTRIBUTE {
  char * name;
  int int_val;           // utilise' pour NUM et uniquement pour NUM
  type type_val;
  int offset;
  int if_label;
  int while_label;
  int depth;
  int nbParams;
};

typedef struct ATTRIBUTE * attribute;



attribute new_attribute ();
/* returns the pointeur to a newly allocated (but uninitialized) attribute value structure */

/* increase the offset counter for depth `depth` */
int new_offset(int depth);

/* increase if counter for labels */
int new_if();

/* increase while counter for labels */
int new_while();


#endif

