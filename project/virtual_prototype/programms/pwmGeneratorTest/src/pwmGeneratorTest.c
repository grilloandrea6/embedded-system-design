#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


#define MILLISEC        73400
#define TWO_MILLISEC    146800
#define DPOS            100

#define X_STOP          (110100 - 1500)

#define Y_MIN           (X_STOP + 2500)          
#define Y_MAX           (X_STOP + 42000)


#define ENABLE_BOTH_PWM 0b0011
#define SET_PWM_1       0b0100
#define SET_PWM_2       0b1000
#define KP_X            6
#define KP_Y            6


int main () {
  vga_clear();
printf("eddai %d", __builtin_ctz(0));  
  printf("PWM Test");
  printf("PWM Test");
  printf("PWM Test");
  printf("PWM Test");
  uint32_t dest, pwm_x, pwm_y;


  pwm_x = X_STOP;
  pwm_y = (Y_MIN + Y_MAX) >> 1;

  // asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm_x));
  // while(1){
  // printf("moving X");
  // for(pwm_x = X_STOP - 5000; pwm_x < X_STOP + 5000; pwm_x+= 1){
  //   printf("-");
  //   asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm_x));
  //   for(volatile int j = 0; j < 300; j++);
  // }
  // printf("inverting\n");
  // for(pwm_x = X_STOP + 5000; pwm_x > X_STOP - 5000; pwm_x-= 1){
  //   printf("-");
  //   asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm_x));
  //   for(volatile int j = 0; j < 300; j++);
  // }
  // printf("finished\n");
  // }

  int32_t y;
  while(1){
    printf("moving Y");
    for(y = 2500; y < 42000; y+= 5){
      printf("-");
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm_y + y));
      for(volatile int j = 0; j < 300; j++);
    }
    printf("inverting\n");
    for(y = 42000; y > 2500; y-= 5){
      printf("-");
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm_y + y));
      for(volatile int j = 0; j < 300; j++);
    }
    printf("finished\n");
  }
  
      





  // valueA = 0x1000;
  // valueB = MILLISEC;
  // asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  // printf("Result: %d\n", dest);

  // valueA = 0b0011;
  // asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  // while(1) {
  //   printf("going in one direction");
  //   for(int i = MILLISEC; i < TWO_MILLISEC; i+= 1000){
  //     printf("-");
  //     valueA = 0b0111;
  //     valueB = i;
  //     asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  //     for(volatile int j = 0; j < 5000; j++){
  //       printf("");
  //     }
  //   }
    

  //   printf("going in another direction");
  //   for(int i = TWO_MILLISEC; i > MILLISEC; i-=1000){
  //     printf("-");
  //     valueA = 0b0111;
  //     valueB = i;
  //     asm volatile("l.nios_rrr %[out1],%[in1],%[in2],21" : [out1] "=r"(dest) : [in1] "r"(valueA), [in2] "r"(valueB));
  //     for(volatile int j = 0; j < 5000; j++){
  //       printf("");
  //     }
  //   }

  // }
  

}
