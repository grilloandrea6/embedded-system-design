# 0 "support/src/uart.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/uart.c"
# 1 "support/include/uart.h" 1
# 45 "support/include/uart.h"
void uart_init(volatile char* uart);
void uart_wait_rx(volatile char* uart);
void uart_wait_tx(volatile char* uart);
void uart_putc(volatile char* uart, int c);
void uart_puts(volatile char* uart, const char* str);
int uart_getc(volatile char* uart);
# 2 "support/src/uart.c" 2

void uart_init(volatile char* uart) {
    uart[5] = 3 | 0 | 0 | 128;
    uart[0] = 0x17;
    uart[1] = 0;
    uart[3] = 3 | 0 | 0;
}

void uart_wait_rx(volatile char* uart) {
    while ((uart[5] & 0x01) == 0)
        asm volatile("l.nop");
}

void uart_wait_tx(volatile char* uart) {
    while ((uart[5] & 0x40) == 0)
        asm volatile("l.nop");
}

void uart_putc(volatile char* uart, int c) {
    uart_wait_tx(uart);
    *uart = c;
}

void uart_puts(volatile char* uart, const char* str) {
    while (*str)
        uart_putc(uart, *str++);
}

int uart_getc(volatile char* uart) {
    uart_wait_rx(uart);
    return *uart;
}
