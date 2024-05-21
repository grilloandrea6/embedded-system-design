#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

#define MILLISEC 73400
#define TWO_MILLISEC 146800


int main () {
  vga_clear();
  
  printf("PWM Test");
  uint32_t dest, valueA, valueB;
  valueA = 0b0100;
  valueB = MILLISEC;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  printf("Result: %d\n", dest);

  valueA = 0x1000;
  valueB = MILLISEC;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  printf("Result: %d\n", dest);

  valueA = 0b0011;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  while(1) {
    printf("going in one direction");
    for(int i = MILLISEC; i < TWO_MILLISEC; i+= 1000){
      printf("-");
      valueA = 0b0111;
      valueB = i;
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
      for(volatile int j = 0; j < 5000; j++){
        printf("");
      }
    }
    

    printf("going in another direction");
    for(int i = TWO_MILLISEC; i > MILLISEC; i-=1000){
      printf("-");
      valueA = 0b0111;
      valueB = i;
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
      for(volatile int j = 0; j < 5000; j++){
        printf("");
      }
    }

  }
  

}
