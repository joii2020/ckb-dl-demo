
#define CKB_C_STDLIB_PRINTF
#include <stdio.h>

#include "ckb_syscalls.h"


__attribute__((visibility("default")))  int inc_add(int a, int b) {
  printf("-- inc_add ----");

  return a + b;
}
