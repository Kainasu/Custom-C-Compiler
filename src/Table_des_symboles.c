/*
 *  Table des symboles.c
 *
 *  Created by Janin on 12/10/10.
 *  Copyright 2010 LaBRI. All rights reserved.
 *
 */

#include "Table_des_symboles.h"
#include "Attribute.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define SIZE 100
#define BUFFER_SIZE 1000
int current_depth = 0;

/*
 *The storage structure is implemented as an array of linked chain
 *One linked chain depending on the depth of the subblock
 */

/* linked element def */

typedef struct elem {
	sid symbol_name;
	attribute symbol_value;
	struct elem * next;
} elem;

/* array of linked chain */
static elem* storage[SIZE] = { NULL };

//static elem * storage=NULL;


/* get the symbol value of symb_id from the symbol table at depth*/
attribute get_symbol_value(sid symb_id, int depth) {
	elem * tracker=storage[depth];

	/* look into the linked list for the symbol value */
	while (tracker) {
		if (tracker -> symbol_name == symb_id) return tracker -> symbol_value; 
		tracker = tracker -> next;
	}
    
	/* if not found does cause an error */
	//fprintf(stderr,"Error : symbol %s is not a valid defined symbol\n",(char *) symb_id);
	//exit(-1);
	return NULL;
};

/* set the value of symbol symb_id to value in symbol table at depth*/
attribute set_symbol_value(sid symb_id,attribute value, int depth) {

	elem * tracker;
	
	/* look for the presence of symb_id in storage */
	
	tracker = storage[depth];
	while (tracker) {
		if (tracker -> symbol_name == symb_id) {
			tracker -> symbol_value = value;
			return tracker -> symbol_value;
		}
		tracker = tracker -> next;
	}
	
	/* otherwise insert it at head of storage with proper value */
	
	tracker = malloc(sizeof(elem));
	tracker -> symbol_name = symb_id;
	tracker -> symbol_value = value;
	tracker -> next = storage[depth];
	storage[depth] = tracker;
	return storage[depth] -> symbol_value;
}

/* erase the symbol table at depth */
void reset_symbols(int depth){
  elem * tracker;
  tracker = storage[depth];
  while (tracker) {   
    free(tracker->symbol_value);
    tracker = tracker->next;
    storage[depth] = NULL;
    storage[depth] = tracker;
  }
}

/* find the nearest symbol to the current block */
attribute get_nearest_symbol(attribute id, int current_depth){
  while (current_depth >=0){
    attribute a = get_symbol_value(id->name, current_depth);
    if (a != NULL)
      return a;
    current_depth--;
  }
  /* if not found does cause an error */
  fprintf(stderr,"Error : symbol %s is undeclared\n", id->name);
  exit(-1);
  return NULL;
}

/*get the mp position of the `depth`th encompassing the current block */
char * get_mp_position(int depth){
  char * buffer = (char*) malloc (BUFFER_SIZE * sizeof(char));
  for (int i = 0; i < depth; i++)
    strcat(buffer, "stack[");
  strcat(buffer, "mp");
  for (int j = 0; j < depth; j++)
    strcat(buffer, " -1]");
  return buffer;
}


  
    
      
