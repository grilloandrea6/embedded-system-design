#include <stdio.h>
#include <stdint.h>

#define BUF_SIZE    13
#define BURST_SIZE  3

int DMAtest2 () {
  volatile uint32_t buffer[BUF_SIZE+5];
  volatile uint32_t ret, ctrl;

  for(volatile uint32_t i = 0; i < BUF_SIZE+5; i++)
    buffer[i] = 321 + i;

  // write bus address - buffer
  ctrl = 0x3 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"((uint32_t) buffer));
  ctrl = 0x2 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  printf("bus address %d %d\n", ret, (uint32_t) buffer);
  if(ret != (uint32_t) buffer)
  {
    printf("Error in reading bus address.\n");
    return -1;
  }

  // write memory address - start at 0
  ctrl = 0x5 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  ctrl = 0x4 << 9;
  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(ctrl), [in2] "r"(0));
  printf("memory address %d %d \n", ret, 0);
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
  printf("burst size %d %d\n", ret, BURST_SIZE);
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
  printf("block size %d %d\n", ret, BUF_SIZE);
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
    } else break;
  }
  printf("DMA is free\n");


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

  for(uint32_t i = 0; i < 20; i++) // ToDo: sizeof(indexes)/sizeof(uint32_t)
  {
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 14" : [out1] "=r"(ret) : [in1] "r"(i), [in2] "r"(0));
    printf("read memory at index %d, value %d\n",i, ret);
  }

  printf("did it work? :)\n");

}
