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
  vga[2] = swap_u32(1);
  vga[3] = swap_u32((uint32_t) &rgb565[0]);

  while(1) {
    //asm volatile ("l.nios_rrc r0,%[in1],r0,0x6"::[in1]"r"(2000000)); // wait 2 s

    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    int sum_pixels = 0, sum_index_pixels = 0, sum_lineindex_pixels_per_line = 0;
    int result, index_pixels_per_line, pixels_per_line;

    for (volatile int i = 0; i < camParams.nrOfLinesPerImage; i++) {
      asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result):[in1]"r"(16),[in2]"r"(i));
      index_pixels_per_line = result >> 12;
      pixels_per_line = result & 0xFFF;
      sum_pixels += pixels_per_line;
      sum_index_pixels += index_pixels_per_line;
      sum_lineindex_pixels_per_line += pixels_per_line * i;
    }

    // sum è il numero di tutti gli 1
    // sum_index è la somma di tutti quelli di sinistra
    // sum_pixel è la somma di dx * i
    

    if(sum_pixels > 100){
      int avg_line  = sum_index_pixels / sum_pixels;
      int avg_pixel = sum_lineindex_pixels_per_line / sum_pixels;

      for(int i = avg_line - 3; i < avg_line + 3; i++){
       for(int j = avg_pixel - 3; j < avg_pixel + 3; j++){
          rgb565[j*camParams.nrOfPixelsPerLine+i] = 0xFFFF;
        }
      }
      //printf("avg line %d avg pixel %d\n", avg_line, avg_pixel);
    } else printf("not detected\n");
    

  }
}
