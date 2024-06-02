#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

int main () {
  volatile uint16_t rgb565[640*480];
  volatile uint8_t grayscale[640*480];
  volatile uint32_t result, cycles,stall,idle;
  volatile unsigned int *vga = (unsigned int *) 0X50000020;
  camParameters camParams;
  vga_clear();
  
  printf("Initialising camera (this takes up to 3 seconds)!\n" );
  camParams = initOv7670(VGA);
  printf("Done!\n" );
  printf("NrOfPixels : %d\n", camParams.nrOfPixelsPerLine );
  result = (camParams.nrOfPixelsPerLine <= 320) ? camParams.nrOfPixelsPerLine | 0x80000000 : camParams.nrOfPixelsPerLine;
  vga[0] = swap_u32(result);
  printf("NrOfLines  : %d\n", camParams.nrOfLinesPerImage );
  result =  (camParams.nrOfLinesPerImage <= 240) ? camParams.nrOfLinesPerImage | 0x80000000 : camParams.nrOfLinesPerImage;
  vga[1] = swap_u32(result);
  printf("PCLK (kHz) : %d\n", camParams.pixelClockInkHz );
  printf("FPS        : %d\n", camParams.framesPerSecond );
  uint32_t * rgb = (uint32_t *) &rgb565[0];
  uint32_t grayPixels;
  vga[2] = swap_u32(2);
  vga[3] = swap_u32((uint32_t) &grayscale[0]);
  //while(1) {
  for (volatile int cazzo = 0; cazzo < 3; cazzo++) {
    uint32_t * gray = (uint32_t *) &grayscale[0];
    // takeSingleImageBlocking((uint32_t) &rgb565[0]);
    // takeSingleImageBlocking((uint32_t) &rgb565[0]);
    // takeSingleImageBlocking((uint32_t) &rgb565[0]);
    // takeSingleImageBlocking((uint32_t) &rgb565[0]);
    // takeSingleImageBlocking((uint32_t) &rgb565[0]);
    
    for (volatile int i = 0; i < 10; i++) {
      volatile int result;
      asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result):[in1]"r"(0x1 << 20),[in2]"r"(i));
      
 
      printf("reading line %d value %d\n", i, (result));
    }

    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    printf("TAKEN IMAGE\n\n");
    volatile int result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10;

    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result0):[in1]"r"(0x1 << 20),[in2]"r"(0));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result1):[in1]"r"(0x1 << 20),[in2]"r"(0));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result2):[in1]"r"(0x1 << 20),[in2]"r"(1));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result3):[in1]"r"(0x1 << 20),[in2]"r"(2));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result4):[in1]"r"(0x1 << 20),[in2]"r"(1));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result5):[in1]"r"(0x1 << 20),[in2]"r"(4));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result6):[in1]"r"(0x1 << 20),[in2]"r"(5));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result7):[in1]"r"(0x1 << 20),[in2]"r"(6));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result8):[in1]"r"(0x1 << 20),[in2]"r"(7));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result9):[in1]"r"(0x1 << 20),[in2]"r"(8));
    asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result10):[in1]"r"(0x1 << 20),[in2]"r"(9));
    
    printf("reading line 0 value %d\n", (result0));
    printf("reading line 0 value %d\n", (result1));
    printf("reading line 1 value %d\n", (result2));
    printf("reading line 2 value %d\n", (result3));
    printf("reading line 1 value %d\n", (result4));
    printf("reading line 4 value %d\n", (result5));
    printf("reading line 5 value %d\n", (result6));
    printf("reading line 6 value %d\n", (result7));
    printf("reading line 7 value %d\n", (result8));
    printf("reading line 8 value %d\n", (result9));
    printf("reading line 9 value %d\n", (result10));



    // for (volatile int i = 0; i < 10; i++) {
    //   volatile int result;
    //   asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result):[in1]"r"(0x1 << 20),[in2]"r"(i));
      
 
    //   printf("reading line %d value %d\n", i, (result));
    // }
  }
}
