# 0 "support/src/platform.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/platform.c"
# 1 "support/include/platform.h" 1
# 10 "support/include/platform.h"
void platform_init();
# 2 "support/src/platform.c" 2

# 1 "support/include/uart.h" 1
# 45 "support/include/uart.h"
void uart_init(volatile char* uart);
void uart_wait_rx(volatile char* uart);
void uart_wait_tx(volatile char* uart);
void uart_putc(volatile char* uart, int c);
void uart_puts(volatile char* uart, const char* str);
int uart_getc(volatile char* uart);
# 4 "support/src/platform.c" 2
# 1 "support/include/vga.h" 1







void vga_clear();
void vga_textcorr(unsigned int value);
void vga_putc(int c);
void vga_puts(const char* str);
# 5 "support/src/platform.c" 2

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
# 7 "support/src/platform.c" 2

void platform_init() {
    uart_init((volatile char*)0x50000000);
}

void _putchar(char c) {
    uart_putc((volatile char*)0x50000000, c);
    vga_putc(c);
}

int putchar(int c) {
    _putchar(c);
    return 0;
}

int puts(const char *s) {
    uart_puts((volatile char*)0x50000000, s);
    uart_putc((volatile char*)0x50000000, (int) '\n');

    vga_puts(s);
    vga_putc((int)'\n');
    return 0;
}

int getchar(void) {
    return uart_getc((volatile char*)0x50000000);
}
