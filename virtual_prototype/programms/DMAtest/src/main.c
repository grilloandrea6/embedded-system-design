#include <stdio.h>
#include <stdint.h>
#include <vga.h>

int DMAtest1();
int DMAtest2();
int DMAtest3();

int main() {
  vga_clear();

  printf("-------------------------------\nRunning dma test 1\n-------------------------------\n");
  DMAtest1();

  printf("\n\n-------------------------------\nRunning dma test 2\n-------------------------------\n");
  DMAtest2();

  printf("\n\n-------------------------------\nRunning dma test 3\n-------------------------------\n");
  DMAtest3();
}
