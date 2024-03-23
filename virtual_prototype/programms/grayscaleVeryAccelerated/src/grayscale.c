#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

#define PROFILE       1
#define TEST_FUNCTION 0

int main () {
  volatile uint16_t rgb565[640*480];
  volatile uint8_t grayscale[640*480];
  volatile uint32_t result,cycles,stall,idle;
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

  vga[2] = swap_u32(2);
  vga[3] = swap_u32((uint32_t) &grayscale[0]);

#if PROFILE
  // resetting counters
  asm volatile ("l.nios_rrr r0, r0, %[in2], 0x8" :: [in2] "r" (0xF << 8));
#endif

  while(1) {
#if PROFILE
    // start all counters
    asm volatile ("l.nios_rrr r0, r0, %[in2], 0x8" :: [in2] "r" (0xF));
#endif

    takeSingleImageBlocking((uint32_t) rgb);
    for (int line = 0; line < camParams.nrOfLinesPerImage; line++) {
      for (int pixel = 0; pixel < camParams.nrOfPixelsPerLine; pixel += 4) {
#if TEST_FUNCTION
        rgb565[line*camParams.nrOfPixelsPerLine+pixel] = 0x1253;
        rgb565[line*camParams.nrOfPixelsPerLine+pixel+1] = 0x34FA;
        rgb565[line*camParams.nrOfPixelsPerLine+pixel+2] = 0x56BC;
        rgb565[line*camParams.nrOfPixelsPerLine+pixel+3] = 0x78DE;

        volatile uint32_t rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel]);
        volatile uint32_t red1 = ((rgb >> 11) & 0x1F) << 3;
        volatile uint32_t green1 = ((rgb >> 5) & 0x3F) << 2;
        volatile uint32_t blue1 = (rgb & 0x1F) << 3;
        volatile uint32_t gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;
        printf("software value 0 %x \n", gray);

        rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel+1]);
        red1 = ((rgb >> 11) & 0x1F) << 3;
        green1 = ((rgb >> 5) & 0x3F) << 2;
        blue1 = (rgb & 0x1F) << 3;
        gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;
        printf("software value 1 %x \n", gray);

        rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel+2]);
        red1 = ((rgb >> 11) & 0x1F) << 3;
        green1 = ((rgb >> 5) & 0x3F) << 2;
        blue1 = (rgb & 0x1F) << 3;
        gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;
        printf("software value 2 %x \n", gray);

        rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel+3]);
        red1 = ((rgb >> 11) & 0x1F) << 3;
        green1 = ((rgb >> 5) & 0x3F) << 2;
        blue1 = (rgb & 0x1F) << 3;
        gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;
        printf("software value 3 %x \n\n", gray);

        volatile uint32_t rgbA = *(uint32_t*)&rgb565[line*camParams.nrOfPixelsPerLine+pixel];

        volatile uint32_t rgbB = *(uint32_t*)&rgb565[line*camParams.nrOfPixelsPerLine+pixel + 2];

        volatile uint32_t grayAcc;
        
        asm volatile("l.nios_rrr %[out1], %[in1], %[in2], 13" : [out1] "=r " (grayAcc) : [in1]"r" (rgbA),[in2]"r"(rgbB));

        *(uint32_t*)&grayscale[line*camParams.nrOfPixelsPerLine+pixel] = grayAcc;

        printf("output assigned value 0 %x\n", grayscale[line*camParams.nrOfPixelsPerLine+pixel]);
        printf("output assigned value 1 %x\n", grayscale[line*camParams.nrOfPixelsPerLine+pixel+1]);
        printf("output assigned value 2 %x\n", grayscale[line*camParams.nrOfPixelsPerLine+pixel+2]);
        printf("output assigned value 3 %x\n", grayscale[line*camParams.nrOfPixelsPerLine+pixel+3]);
        return 0;
#else
        uint32_t rgbA = *(uint32_t*)&rgb565[line*camParams.nrOfPixelsPerLine+pixel];
        uint32_t rgbB = *(uint32_t*)&rgb565[line*camParams.nrOfPixelsPerLine+pixel + 2];
        uint32_t gray;
        
        asm volatile("l.nios_rrr %[out1], %[in1], %[in2], 13" : [out1] "=r " (gray) : [in1]"r" (rgbA),[in2]"r"(rgbB));

        *(uint32_t*)&grayscale[line*camParams.nrOfPixelsPerLine+pixel] = gray;
#endif
      }
    }

#if PROFILE
    // disable all counters
    asm volatile("l.nios_rrr r0, r0, %[in2], 0x8" :: [in2] "r" ((uint32_t) (0xF << 4)));

    // read values
    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (cycles):[in1] "r" (0));
    printf("CPU cycles\t:\t %u\n", cycles);

    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (stall):[in1] "r" (1));
    printf("Stall cycles\t:\t %u\n", stall);

    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (idle):[in1] "r" (2));
    printf("Bus idle\t:\t %u\n", idle);

    asm volatile("l.nios_rrr %[out1], %[in1], r0, 0x8 " : [out1] "=r " (cycles):[in1] "r" (3));
    printf("CPU cycles\t:\t %u\n\n", cycles);

    // resetting counters
    asm volatile ("l.nios_rrr r0, r0, %[in2], 0x8" :: [in2] "r" (0xF << 8)); 
#endif

  }
}
