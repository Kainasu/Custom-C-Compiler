#include "Attribute.h"

#include <stdlib.h>

#define SIZE

static int of[SIZE] = {0};



attribute new_attribute () {
  attribute r;
  r  = malloc (sizeof (struct ATTRIBUTE));
  return r;
};


int new_offset(int depth){
  return of[depth]++;
}

int new_if() {
  static int iflabel = 0;
  return iflabel++;
}

int new_while(){
  static int  wlabel = 0;
  return wlabel++;
}
