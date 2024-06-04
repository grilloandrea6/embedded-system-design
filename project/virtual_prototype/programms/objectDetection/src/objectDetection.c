#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

int main () {
  const int lowerRed = 60;
  const int upperRed = 100;
  const int lowerGreen = 0;
  const int upperGreen = 40;
  const int lowerBlue = 20;
  const int upperBlue = 60;

  volatile uint16_t rgb565[640*480];
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
  vga[2] = swap_u32(1);
  vga[3] = swap_u32((uint32_t) &rgb565[0]);
  while(1) {
    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    // Start profiling counters
    asm volatile ("l.nios_rrr r0,r0,%[in2],0xC"::[in2]"r"(7));

    int sum_line = 0, sum_pixel = 0, sum = 0;
    
    for (int line = 0; line < camParams.nrOfLinesPerImage; line++) {
      for (int pixel = 0; pixel < camParams.nrOfPixelsPerLine; pixel++) {
        uint16_t rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel]);
    
        uint8_t red1 = ((rgb >> 11) & 0x1F) << 3;
        uint8_t green1 = ((rgb >> 5) & 0x3F) << 2;
        uint8_t blue1 = (rgb & 0x1F) << 3;

        if(lowerRed < red1 && red1 < upperRed  &&
            lowerGreen < green1 && green1 < upperGreen &&
            lowerBlue < blue1 && blue1 < upperBlue){
          sum++;
          sum_line += line;
          sum_pixel += pixel;
        } else {
          uint8_t gray = ((red1*54+green1*183+blue1*19) >> 8) & 0xFF;
          uint16_t gray16 = (gray & 0xF8) << 8 | (gray & 0xFC) << 3 | (gray & 0xF8) >> 3;
          rgb565[line*camParams.nrOfPixelsPerLine+pixel] = swap_u16(gray16);
        }
      }
    }

    if(sum > 100){
      int avg_line = sum_line/sum;
      int avg_pixel = sum_pixel/sum;
      for(int i = avg_line - 3; i < avg_line + 3; i++){
       for(int j = avg_pixel - 3; j < avg_pixel + 3; j++){
          rgb565[j*camParams.nrOfPixelsPerLine+i] = 0xFFFF;
        }
      }
    }

    // Stop profiling counters
    asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    printf("nrOfCycles: total cycles: %d stall: %d idle: %d\n", cycles, stall, idle);
  }
}
