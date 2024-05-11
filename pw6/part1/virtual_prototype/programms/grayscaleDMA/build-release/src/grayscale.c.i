# 0 "src/grayscale.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "src/grayscale.c"
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
# 2 "src/grayscale.c" 2
# 1 "support/include/ov7670.h" 1


# 1 "support/include/stdint.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 1 3 4
# 34 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 3 4

# 34 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 3 4
typedef signed char int8_t;


typedef short int int16_t;


typedef long int int32_t;


typedef long long int int64_t;


typedef unsigned char uint8_t;


typedef short unsigned int uint16_t;


typedef long unsigned int uint32_t;


typedef long long unsigned int uint64_t;




typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef long int int_least32_t;
typedef long long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef short unsigned int uint_least16_t;
typedef long unsigned int uint_least32_t;
typedef long long unsigned int uint_least64_t;



typedef int int_fast8_t;
typedef int int_fast16_t;
typedef int int_fast32_t;
typedef long long int int_fast64_t;
typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef long long unsigned int uint_fast64_t;




typedef int intptr_t;


typedef unsigned int uintptr_t;




typedef long long int intmax_t;
typedef long long unsigned int uintmax_t;
# 5 "support/include/stdint.h" 2
# 4 "support/include/ov7670.h" 2







# 10 "support/include/ov7670.h"
typedef enum resolution_t {VGA,QVGA,QQVGA} resolution;
typedef struct camParam_t {
  uint32_t nrOfPixelsPerLine;
  uint32_t nrOfLinesPerImage;
  uint32_t pixelClockInkHz;
  uint32_t framesPerSecond;
} camParameters;

int readOv7670Register( int reg );
void writeOv7670Register(int reg , int value);
camParameters initOv7670(resolution res);
void takeSingleImageBlocking(uint32_t framebuffer);
void takeSingleImageNonBlocking(uint32_t framebuffer);
void waitForNextImage();
void enableContinues(uint32_t framebuffer);
void disableContinues();
# 3 "src/grayscale.c" 2
# 1 "support/include/swap.h" 1



# 1 "support/include/defs.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 1 3 4
# 5 "support/include/defs.h" 2
# 5 "support/include/swap.h" 2





static inline __attribute__((always_inline)) uint32_t swap_u32(uint32_t src) {
    uint32_t dest;
    asm volatile("l.nios_rrr %[out1],%[in1],r0,0x1" : [out1] "=r"(dest) : [in1] "r"(src));
    return dest;
}

static inline __attribute__((always_inline)) uint16_t swap_u16(uint16_t src) {
    uint16_t dest;
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2],0x1" : [out1] "=r"(dest) : [in1] "r"(src), [in2] "r"(1));
    return dest;
}
# 4 "src/grayscale.c" 2
# 1 "support/include/vga.h" 1







void vga_clear();
void vga_textcorr(unsigned int value);
void vga_putc(int c);
void vga_puts(const char* str);
# 5 "src/grayscale.c" 2



int main () {
  volatile uint32_t ret;
  volatile uint16_t rgb565[640*480];
  volatile uint8_t grayscale[640*480];
  volatile uint32_t result, cycles,stall,idle;
  volatile unsigned int *vga = (unsigned int *) 0X50000020;
  camParameters camParams;
  vga_clear();

  printf_("Initialising camera (this takes up to 3 seconds)!\n" );
  camParams = initOv7670(VGA);
  printf_("Done!\n" );
  printf_("NrOfPixels : %d\n", camParams.nrOfPixelsPerLine );
  result = (camParams.nrOfPixelsPerLine <= 320) ? camParams.nrOfPixelsPerLine | 0x80000000 : camParams.nrOfPixelsPerLine;
  vga[0] = swap_u32(result);
  printf_("NrOfLines  : %d\n", camParams.nrOfLinesPerImage );
  result = (camParams.nrOfLinesPerImage <= 240) ? camParams.nrOfLinesPerImage | 0x80000000 : camParams.nrOfLinesPerImage;
  vga[1] = swap_u32(result);
  printf_("PCLK (kHz) : %d\n", camParams.pixelClockInkHz );
  printf_("FPS        : %d\n", camParams.framesPerSecond );
  uint32_t grayPixels;
  vga[2] = swap_u32(2);
  vga[3] = swap_u32((uint32_t) &grayscale[0]);


  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x9 << 9), [in2] "r"(31));

  while(1)
  {

    takeSingleImageBlocking((uint32_t) &rgb565[0]);


    asm volatile ("l.nios_rrr r0,r0,%[in2],0xC"::[in2]"r"(7));





    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) rgb565));

    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x5 << 9), [in2] "r"(0));

    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x7 << 9), [in2] "r"(256));


    do{
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));

    } while(ret & 0x1);


    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x1));


    do{
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));

    } while(ret & 0x1);



    for(volatile int i = 0; i < 600; i++) {
      uint32_t * rgb = &((uint32_t *)rgb565)[256 * (i + 1)];


      if(i != 599) {


        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) rgb));

        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x5 << 9), [in2] "r"((i&0x1) ? 0 : 256));


        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x7 << 9), [in2] "r"(256));


        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x1));
      }

      for (volatile int j = 0, k = 0; j < 256; j += 2, k++) {
        int z = (i&0x1) * 256;
        uint32_t pixel12, pixel34;

        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(pixel12) : [in1] "r"(z + j), [in2] "r"(0));
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(pixel34) : [in1] "r"(z + j + 1), [in2] "r"(0));


        asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0x9":[out1]"=r"(grayPixels):[in1]"r"(swap_u32(pixel34)),[in2]"r"(swap_u32(pixel12)));


        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x200 | (z + k)), [in2] "r"(grayPixels));
      }


      do{
         asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));

      } while(ret & 0x1);




      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) &((uint32_t *)&grayscale[0])[i*128]));


      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x5 << 9), [in2] "r"((i&0x1) * 256));

      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x7 << 9), [in2] "r"(128));

      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x2));


      do{
         asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));

      } while(ret & 0x1);
    }


    asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    printf_("nrOfCycles: %d %d %d\n", cycles, stall, idle);
  }
}
