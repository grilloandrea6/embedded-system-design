#include <stdio.h>
#include <stdint.h>

#define BUF_SIZE    400
#define BURST_SIZE  1

int DMAtest3 () {
  /*volatile uint32_t buffer[BUF_SIZE];
  volatile uint32_t ret, ctrl;

  for(volatile uint32_t i = 0; i < BUF_SIZE; i++)
    buffer[i] = i;

  // write bus address - buffer
  ctrl = 0x3 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(buffer));
  ctrl = 0x2 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  if(ret != buffer)
  {
    printf("Error in reading bus address.\n");
    return -1;
  }

  // write memory address - start at 0
  ctrl = 0x5 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  ctrl = 0x4 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  if(ret != 0)
  {
    printf("Error in reading memory address\n");
    return -1;
  }

  // write burst size - BURST_SIZE
  ctrl = 0x9 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(BURST_SIZE));
  ctrl = 0x8 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  if(ret != BURST_SIZE)
  {
    printf("Error in reading burst size\n");
    return -1;
  }

  // write block size - BUF_SIZE
  ctrl = 0x7 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(BUF_SIZE));
  ctrl = 0x6 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  if(ret != BUF_SIZE)
  {
    printf("Error in reading block size\n");
    return -1;
  }

  // checking if the DMA is available
  printf("check if DMA is available\n");
  while(1)
  {
    // read status register
    ctrl = 0xA << 9;
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0x1));
      
    if(ret & 0x1)
    {
      printf("-");
    }
  }
  printf("DMA is free");

  // set control register - 0x1
  ctrl = 0xB << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0x1));
  printf("control register set\n");

  while(1)
  {
    // read status register
    ctrl = 0xA << 9;
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0x1));
    
    if((ret >> 1) & 0x1)
    {
      printf("bus error\n");
      return -1;
    }

    if(ret & 0x1)
      printf("-");
    else
    {
      printf("transfer complete");
      break;
    }
  }

  printf("evvai!\n");
  printf("now we should check the result\n");

  uint32_t indexes[] = {15, 18, 35, 183, 237, 391};
  for(uint32_t i = 0; i < 6; i++) // ToDo: sizeof(indexes)/sizeof(uint32_t)
  {
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(indexes[i]), [in2] "r"(0));
    printf("read memory at index %d, value %d\n",indexes[i], ret);
  }

  printf("did it work? :)\n");
*/
  return 0;
}