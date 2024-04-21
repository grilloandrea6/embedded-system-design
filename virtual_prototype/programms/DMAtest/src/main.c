#include <stdio.h>
#include <stdint.h>
#include <vga.h>

int DMAtest1();
int DMAtest2();
int DMAtest3();

int main() {
  vga_clear();

  printf("running dma test 1\n");
  DMAtest1();

  printf("running dma test 2\n");
  DMAtest2();

  // printf("running dma test 3\n");
  // DMAtest3();
}
