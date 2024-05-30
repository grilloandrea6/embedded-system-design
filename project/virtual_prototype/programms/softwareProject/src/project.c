#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


#define MILLISEC        73400
#define TWO_MILLISEC    146800
#define DPOS            100

#define X_STOP          110100

#define Y_MIN           X_STOP + 2500           
#define Y_MAX           X_STOP + 42000


#define ENABLE_BOTH_PWM 0b0011
#define SET_PWM_1       0b0100
#define SET_PWM_2       0b1000
#define KP_X            6
#define KP_Y            6



int main () {
  
  uint32_t pwm_x = X_STOP;
  uint32_t pwm_y = (Y_MIN + Y_MAX) >> 1;
  uint32_t dest;
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
    int sum_line = 0, sum_pixel = 0, sum = 0;
    for (int line = 0; line < camParams.nrOfLinesPerImage; line++) {
      for (int pixel = 0; pixel < camParams.nrOfPixelsPerLine; pixel++) {
        uint16_t rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel]);

        
        uint8_t red1 = ((rgb >> 11) & 0x1F) << 3;
        uint8_t green1 = ((rgb >> 5) & 0x3F) << 2;
        uint8_t blue1 = (rgb & 0x1F) << 3;

        uint32_t gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;

        int lowerRed = 60;
        int upperRed = 100;
        
        int lowerGreen = 0;
        int upperGreen = 40;

        int lowerBlue = 20;
        int upperBlue = 60;

        if(lowerRed < red1 && red1 < upperRed  &&
            lowerGreen < green1 && green1 < upperGreen &&
            lowerBlue < blue1 && blue1 < upperBlue){
          sum++;
          sum_line += line;
          sum_pixel += pixel;
        }
        
        grayscale[line*camParams.nrOfPixelsPerLine+pixel] = gray;
      }
    }

    if(sum > 100){
      int avg_line = sum_line/sum;
      int avg_pixel = sum_pixel/sum;
      for(int i = avg_line - 3; i < avg_line + 3; i++){
       for(int j = avg_pixel - 3; j < avg_pixel + 3; j++){
          grayscale[i*camParams.nrOfPixelsPerLine+j] = 0xFF;
        }
      }

      pwm_y += KP_Y * (avg_line  - (camParams.nrOfLinesPerImage >> 1));
      pwm_x = X_STOP + KP_X * (avg_pixel - (camParams.nrOfPixelsPerLine >> 1));

      if(pwm_y < Y_MIN)
        pwm_y = Y_MIN;
      else if(pwm_y > Y_MAX)
        pwm_y = Y_MAX;

      if(pwm_x > X_STOP + 3000) {
        printf("clamping x upper\n");        
        pwm_x = X_STOP + 3000;
      } else if(pwm_x < X_STOP - 3000) {
        printf("clamping xlower\n");
        pwm_x = X_STOP - 3000;
      }
      printf("avg line %d avg pixel %d\n", avg_line, avg_pixel);
      printf("pwm_x %d pwm_y %d\n", pwm_x, pwm_y);
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm_x));
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm_y));
      
    } else printf("not detected\n");
  }
}
