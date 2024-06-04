#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


#define MILLISEC        73400
#define TWO_MILLISEC    146800

#define MIDDLE          110100

#define DEG             408

#define ENABLE_BOTH_PWM 0b0011

#define SET_PWM_1       0b0100
#define SET_PWM_2       0b1000



int main () {
  vga_clear();

  volatile uint32_t pwm = MIDDLE - 35 * DEG;
  printf("start\n");

  while(1){
    printf("Direction 1\n");
    for (int i = 0 ; i < 70; i++) {
      pwm += DEG;
      asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm));
      asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm));
      asm volatile ("l.nios_rrc r0,%[in1],r0,0x6"::[in1]"r"(15000)); // wait 15 ms
    }
    printf("Direction 2\n");
    for (int i = 0 ; i < 70; i++) {
      pwm -= DEG;
      asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_1), [in2] "r"(pwm));
      asm volatile("l.nios_rrr r0,%[in1],%[in2],21" :: [in1] "r"(ENABLE_BOTH_PWM | SET_PWM_2), [in2] "r"(pwm));
      asm volatile ("l.nios_rrc r0,%[in1],r0,0x6"::[in1]"r"(15000)); // wait 15 ms
    }
  }
  return 0;
}
