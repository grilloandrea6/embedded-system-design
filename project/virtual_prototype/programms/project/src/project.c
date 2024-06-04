#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

#define MIDDLE          110100

#define DEG             20

#define MAX             124380
#define MIN             95820 

#define ENABLE_BOTH_PWM 0b0011

#define SET_PWM_1       0b0100
#define SET_PWM_2       0b1000

#define MIDDLE_LINE     240
#define MIDDLE_PIXEL    320

int main () {
  volatile uint16_t rgb565[640*480];
  volatile uint32_t result, cycles,stall,idle;
  uint32_t pwm_x = MIDDLE, pwm_y = MIDDLE;
  volatile unsigned int *vga = (unsigned int *) 0X50000020;
  camParameters camParams;
  vga_clear();

  printf("Starting servos.\n");
  asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm_x));
  asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm_y));
  
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
  vga[2] = swap_u32(1);
  vga[3] = swap_u32((uint32_t) &rgb565[0]);

  while(1) {
    // asm volatile ("l.nios_rrc r0,%[in1],r0,0x6"::[in1]"r"(2000000)); // wait 2 s

    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    // Start profiling counters
    asm volatile ("l.nios_rrr r0,r0,%[in2],0xC"::[in2]"r"(7));

    int sum_pixels = 0, sum_index_pixels = 0, sum_lineindex_pixels_per_line = 0;
    int result, index_pixels_per_line, pixels_per_line;

    for (int i = 0; i < camParams.nrOfLinesPerImage; i++) {
      asm volatile ("l.nios_rrc %[out1],%[in1],%[in2],0x7":[out1]"=r"(result):[in1]"r"(16),[in2]"r"(i));
      index_pixels_per_line = result >> 12;
      pixels_per_line = result & 0xFFF;
      sum_pixels += pixels_per_line;
      sum_index_pixels += index_pixels_per_line;
      sum_lineindex_pixels_per_line += pixels_per_line * i;
    }

    // To profile just the averaging cycle
    // asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    // asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    // asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    // printf("nrOfCycles: total cycles: %d stall: %d idle: %d\n", cycles, stall, idle);

    if(sum_pixels > 100){
      int avg_line  = sum_index_pixels / sum_pixels;
      int avg_pixel = sum_lineindex_pixels_per_line / sum_pixels;

      // printf("avg line %d avg pixel %d \n", avg_line, avg_pixel);

      for(int i = avg_line - 3; i < avg_line + 3; i++){
       for(int j = avg_pixel - 3; j < avg_pixel + 3; j++){
          rgb565[j*camParams.nrOfPixelsPerLine+i] = 0xFFFF;
        }
      }
            
      if(avg_line < MIDDLE_LINE) pwm_x = pwm_x < MIN ? MIN : (pwm_x - DEG);
      else                       pwm_x = pwm_x > MAX ? MAX : (pwm_x + DEG);

      if(avg_pixel < MIDDLE_PIXEL) pwm_y = pwm_y < MIN ? MIN : (pwm_y - DEG);
      else                         pwm_y = pwm_y > MAX ? MAX : (pwm_y + DEG);

      asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm_y));
      asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm_x));
    }

    // To profile the whole code
    asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    printf("nrOfCycles: total cycles: %d stall: %d idle: %d\n", cycles, stall, idle);
  }
}
