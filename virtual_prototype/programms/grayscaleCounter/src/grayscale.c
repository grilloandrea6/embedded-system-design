#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


int main () {
  volatile uint16_t rgb565[640*480];
  volatile uint8_t grayscale[640*480];
  volatile uint32_t result, cycles,stall,idle;
  volatile uint32_t controlCustomInstr, resultProfile;
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



  while(1) {
    printf ("Before resetting\n");

    // reset all counters
    controlCustomInstr = 0xF << 20;
    // asm volatile ("l.nios_rrr r0, r0, %[in2], 0x8" :: [in2] "r" (controlCustomInstr));
    printf ("After resetting\n");
    // start all counters
    controlCustomInstr = 0xF << 28;
    asm volatile ("l.nios_rrr r0, r0, %[in2], 0x8" :: [in2] "r" (controlCustomInstr));
    printf ("After starting counters\n");


    uint32_t * gray = (uint32_t *) &grayscale[0];
    takeSingleImageBlocking((uint32_t) &rgb565[0]);
    for (int line = 0; line < camParams.nrOfLinesPerImage; line++) {
      for (int pixel = 0; pixel < camParams.nrOfPixelsPerLine; pixel++) {
        uint16_t rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel]);
        uint32_t red1 = ((rgb >> 11) & 0x1F) << 3;
        uint32_t green1 = ((rgb >> 5) & 0x3F) << 2;
        uint32_t blue1 = (rgb & 0x1F) << 3;
        uint32_t gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;
        grayscale[line*camParams.nrOfPixelsPerLine+pixel] = gray;
      }
    }


    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (result):[in1] "r" (0x0));
    printf ("CPU cycles\t:\t %d\n ", result);

    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (result):[in1] "r" (0x1));
    printf ("Stall cycles\t:\t %d\n ", result);

    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (result):[in1] "r" (0x2));
    printf ("Bus idle\t:\t %d\n ", result);
  }
}
