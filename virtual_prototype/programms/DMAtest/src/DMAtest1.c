#include <stdio.h>
#include <stdint.h>
#include <vga.h>

int DMAtest1 () {
  vga_clear();

  volatile uint32_t val = 4321;
  volatile uint32_t ctrl_base = 0x200, ctrl;
 
  volatile uint32_t ret = 1234;

  for(volatile uint32_t i = 0; i < 500; i++) {
    val = i + 5;
    ctrl = ctrl_base | i;
    printf("writing index %d value %d\n", i, val);
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(val));
    printf("return %d\n", ret);
  }

  printf("\n\n\n");
  for(volatile uint32_t i = 0; i < 500; i++) {
    printf("reading index %d\n", i);
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(i), [in2] "r"(0));
    printf("return %d\n", ret);
  }
}
