#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

// Fixed-point constants
#define FIXED_SHIFT 10
#define FIXED_ONE (1 << FIXED_SHIFT)


void RGB565_to_HSV(uint32_t rr, uint32_t gg, uint32_t bb, uint32_t *h, uint32_t *s, uint32_t *v) {
    // Extracting RGB components from RGB565
    // color->r = (rgb565 >> 11) & 0x1F; // Red: 5 bits
    // color->g = (rgb565 >> 5) & 0x3F;  // Green: 6 bits
    // color->b = rgb565 & 0x1F;         // Blue: 5 bits

    // Normalizing RGB values to the range [0, 1024] (scaled by 2^10)
    int r = rr << (FIXED_SHIFT - 5);
    int g = gg << (FIXED_SHIFT - 6);
    int b = bb << (FIXED_SHIFT - 5);

    // Finding the maximum and minimum values among R, G, and B
    int max = r > g ? (r > b ? r : b) : (g > b ? g : b);
    int min = r < g ? (r < b ? r : b) : (g < b ? g : b);
    int delta = max - min;

    // Calculating hue
    if (delta == 0)
        *h = 0; // undefined, but usually treated as 0
    else if (max == r)
        *h = (((g - b) * 60) / delta) % 360;
    else if (max == g)
        *h = (((b - r) * 60) / delta + 120);
    else
        *h = (((r - g) * 60) / delta + 240);

    // Calculating saturation
    if (max == 0)
        *s = 0;
    else
        *s = ((delta * FIXED_ONE) / max);

    // Calculating value
    *v = max;
}



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
  while(1) {
    uint32_t * gray = (uint32_t *) &grayscale[0];
    takeSingleImageBlocking((uint32_t) &rgb565[0]);
    for (int line = 0; line < camParams.nrOfLinesPerImage; line++) {
      for (int pixel = 0; pixel < camParams.nrOfPixelsPerLine; pixel++) {
        uint16_t rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel]);

        
        uint32_t red1 = ((rgb >> 11) & 0x1F) << 3;
        uint32_t green1 = ((rgb >> 5) & 0x3F) << 2;
        uint32_t blue1 = (rgb & 0x1F) << 3;

        uint32_t gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;


        uint32_t h,s,v;
        RGB565_to_HSV(red1,green1,blue1,&h,&s,&v);
        if(h>360) h = 360;
        if(s>1024) s = 1024;
        if(v>1024) v = 1024;

        //printf("hsv %d %d %d\n", h,s,v);
        if(280 <= h && h <= 350  && 220 <= s && 200 <= v){
          gray = 0xFF;
        }
        
        grayscale[line*camParams.nrOfPixelsPerLine+pixel] = gray;
      }
    }
  }
}
