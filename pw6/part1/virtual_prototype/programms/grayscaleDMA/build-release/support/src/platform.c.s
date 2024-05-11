	.file	"platform.c"
	.section	.text
	.align 4
	.global	platform_init
	.type	platform_init, @function
platform_init:
	l.j	uart_init
	l.movhi	r3, hi(1342177280)
	.size	platform_init, .-platform_init
	.align 4
	.global	_putchar
	.type	_putchar, @function
_putchar:
	l.addi	r1, r1, -8
	l.ori	r17, r0, 24
	l.sw	0(r1), r16
	l.sll	r16, r3, r17
	l.sra	r16, r16, r17
	l.or	r4, r16, r16
	l.sw	4(r1), r9
	l.jal	uart_putc
	l.movhi	r3, hi(1342177280)
	l.or	r3, r16, r16
	l.lwz	r9, 4(r1)
	l.lwz	r16, 0(r1)
	l.j	vga_putc
	l.addi	r1, r1, 8
	.size	_putchar, .-_putchar
	.align 4
	.global	putchar
	.type	putchar, @function
putchar:
	l.addi	r1, r1, -4
	l.sw	0(r1), r9
	l.jal	_putchar
	 l.nop

	l.movhi	r11, hi(0)
	l.lwz	r9, 0(r1)
	l.jr	r9
	l.addi	r1, r1, 4
	.size	putchar, .-putchar
	.align 4
	.global	puts
	.type	puts, @function
puts:
	l.addi	r1, r1, -8
	l.sw	0(r1), r16
	l.or	r4, r3, r3
	l.or	r16, r3, r3
	l.sw	4(r1), r9
	l.jal	uart_puts
	l.movhi	r3, hi(1342177280)
	l.ori	r4, r0, 10
	l.jal	uart_putc
	l.movhi	r3, hi(1342177280)
	l.jal	vga_puts
	l.or	r3, r16, r16
	l.jal	vga_putc
	l.ori	r3, r0, 10
	l.movhi	r11, hi(0)
	l.lwz	r16, 0(r1)
	l.lwz	r9, 4(r1)
	l.jr	r9
	l.addi	r1, r1, 8
	.size	puts, .-puts
	.align 4
	.global	getchar
	.type	getchar, @function
getchar:
	l.j	uart_getc
	l.movhi	r3, hi(1342177280)
	.size	getchar, .-getchar
	.ident	"GCC: (GNU) 13.2.0"
