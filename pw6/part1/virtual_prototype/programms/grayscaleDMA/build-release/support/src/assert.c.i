# 0 "support/src/assert.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/assert.c"
# 1 "support/include/assert.h" 1



# 1 "support/include/defs.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 1 3 4
# 145 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4

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
# 5 "support/include/defs.h" 2
# 1 "support/include/stdint.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 1 3 4
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
# 6 "support/include/defs.h" 2
# 5 "support/include/assert.h" 2






# 10 "support/include/assert.h"
extern int (*assert_printf)(const char*, ...);
extern void assert_die();
# 2 "support/src/assert.c" 2
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
# 3 "support/src/assert.c" 2

int (*assert_printf)(const char*, ...) = &printf_;

void assert_die() {
    puts("dead!");
    while (1);
}
