# 0 "support/src/rtc.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/rtc.c"
# 1 "support/include/rtc.h" 1



void printTimeComplete();
# 2 "support/src/rtc.c" 2
# 1 "support/include/stdio.h" 1







int putchar(int c);
int puts(const char *s);
int getchar(void);





# 1 "support/include/printf.h" 1
# 35 "support/include/printf.h"
# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 1 3 4
# 40 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 3 4

# 40 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 103 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 36 "support/include/printf.h" 2
# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 1 3 4
# 145 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 214 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 329 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef unsigned int wchar_t;
# 425 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef struct {
  long long __max_align_ll __attribute__((__aligned__(__alignof__(long long))));
  long double __max_align_ld __attribute__((__aligned__(__alignof__(long double))));
# 436 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
} max_align_t;
# 37 "support/include/printf.h" 2
# 49 "support/include/printf.h"

# 49 "support/include/printf.h"
void _putchar(char character);
# 61 "support/include/printf.h"
int printf_(const char* format, ...);
# 72 "support/include/printf.h"
int sprintf_(char* buffer, const char* format, ...);
# 87 "support/include/printf.h"
int snprintf_(char* buffer, size_t count, const char* format, ...);
int vsnprintf_(char* buffer, size_t count, const char* format, va_list va);
# 98 "support/include/printf.h"
int vprintf_(const char* format, va_list va);
# 109 "support/include/printf.h"
int fctprintf(void (*out)(char character, void* arg), void* arg, const char* format, ...);
# 17 "support/include/stdio.h" 2
# 3 "support/src/rtc.c" 2




int readRtcRegister( int reg ) {
  volatile int value, result, retry;
  retry = 0;
  value = 0xD1000000 | (reg &0xFF) << 8;
  do {
      asm volatile ("l.nios_rrc %[out1],%[in1],r0,0x5":[out1]"=r"(result):[in1]"r"(value));
      retry++;
  } while (retry < 4 && (result & 0x80000000) != 0);
  return result;
}

void writeRtcRegister(int reg , int value) {
  int val = 0xD0000000 | ((reg&0xFF) << 8) | (value&0xFF);
  asm volatile ("l.nios_rrc r0,%[in1],r0,0x5"::[in1]"r"(val));
}

void printTimeComplete() {
  int old,new;
  old = new = readRtcRegister(0);
  do {
    new = readRtcRegister(0);
    if (old != new) {
      printf_("%02X-%02X-20%02X %02X:%02X:%02X\n", readRtcRegister(4), readRtcRegister(5), readRtcRegister(6), readRtcRegister(2), readRtcRegister(1), new);
      old = new;
    }
  } while (1);
}
