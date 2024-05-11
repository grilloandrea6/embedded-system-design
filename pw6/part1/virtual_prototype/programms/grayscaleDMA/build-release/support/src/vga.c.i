# 0 "support/src/vga.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/vga.c"
# 1 "support/include/vga.h" 1







void vga_clear();
void vga_textcorr(unsigned int value);
void vga_putc(int c);
void vga_puts(const char* str);
# 2 "support/src/vga.c" 2







void vga_clear() {
    asm volatile("l.nios_crr r0,%[in1],r0,0x0" ::[in1] "r"(3));
}

void vga_textcorr(unsigned int value) {
    asm volatile("l.nios_crr r0,%[in2],%[in1],0x0" ::[in1] "r"(value), [in2] "r"(6));
}

void vga_putc(int c) {
    asm volatile("l.nios_crr r0,%[in2],%[in1],0x0" ::[in1] "r"(c), [in2] "r"(2));
}

void vga_puts(const char* str) {
    while (*str)
        vga_putc(*str++);
}
