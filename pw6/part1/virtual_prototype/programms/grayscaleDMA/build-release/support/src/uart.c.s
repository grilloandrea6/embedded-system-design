	.file	"uart.c"
	.section	.text
	.align 4
	.global	uart_init
	.type	uart_init, @function
uart_init:
	l.xori	r17, r0, -125
	l.sb	5(r3), r17
	l.ori	r17, r0, 23
	l.sb	0(r3), r17
	l.sb	1(r3), r0
	l.ori	r17, r0, 3
	l.sb	3(r3), r17
	l.jr	r9
	 l.nop

	.size	uart_init, .-uart_init
	.align 4
	.global	uart_wait_rx
	.type	uart_wait_rx, @function
uart_wait_rx:
.L3:
	l.lbz	r17, 5(r3)
	l.andi	r17, r17, 1
	l.movhi	r19, hi(0)
	l.sfeq	r17, r19
	l.bf	.L4
	 l.nop

	l.jr	r9
	 l.nop

.L4:
#  12 "support/src/uart.c" 1
	l.nop
#  0 "" 2
	l.j	.L3
	 l.nop

	.size	uart_wait_rx, .-uart_wait_rx
	.align 4
	.global	uart_wait_tx
	.type	uart_wait_tx, @function
uart_wait_tx:
.L6:
	l.lbz	r17, 5(r3)
	l.andi	r17, r17, 64
	l.movhi	r19, hi(0)
	l.sfeq	r17, r19
	l.bf	.L7
	 l.nop

	l.jr	r9
	 l.nop

.L7:
#  17 "support/src/uart.c" 1
	l.nop
#  0 "" 2
	l.j	.L6
	 l.nop

	.size	uart_wait_tx, .-uart_wait_tx
	.align 4
	.global	uart_putc
	.type	uart_putc, @function
uart_putc:
	l.addi	r1, r1, -12
	l.sw	0(r1), r16
	l.sw	4(r1), r18
	l.sw	8(r1), r9
	l.or	r18, r3, r3
	l.jal	uart_wait_tx
	l.or	r16, r4, r4
	l.ori	r17, r0, 24
	l.sll	r4, r16, r17
	l.sra	r4, r4, r17
	l.sb	0(r18), r4
	l.lwz	r16, 0(r1)
	l.lwz	r18, 4(r1)
	l.lwz	r9, 8(r1)
	l.jr	r9
	l.addi	r1, r1, 12
	.size	uart_putc, .-uart_putc
	.align 4
	.global	uart_puts
	.type	uart_puts, @function
uart_puts:
	l.addi	r1, r1, -16
	l.sw	0(r1), r16
	l.sw	4(r1), r18
	l.sw	8(r1), r20
	l.sw	12(r1), r9
	l.or	r18, r3, r3
	l.or	r16, r4, r4
	l.lbs	r20, 0(r16)
.L14:
	l.movhi	r17, hi(0)
	l.sfne	r20, r17
	l.bf	.L12
	l.lwz	r9, 12(r1)
	l.lwz	r16, 0(r1)
	l.lwz	r18, 4(r1)
	l.lwz	r20, 8(r1)
	l.jr	r9
	l.addi	r1, r1, 16
.L12:
	l.jal	uart_wait_tx
	l.or	r3, r18, r18
	l.addi	r16, r16, 1
	l.sb	0(r18), r20
	l.j	.L14
	l.lbs	r20, 0(r16)
	.size	uart_puts, .-uart_puts
	.align 4
	.global	uart_getc
	.type	uart_getc, @function
uart_getc:
	l.addi	r1, r1, -8
	l.sw	0(r1), r16
	l.sw	4(r1), r9
	l.jal	uart_wait_rx
	l.or	r16, r3, r3
	l.lbz	r11, 0(r16)
	l.ori	r17, r0, 24
	l.sll	r11, r11, r17
	l.sra	r11, r11, r17
	l.lwz	r16, 0(r1)
	l.lwz	r9, 4(r1)
	l.jr	r9
	l.addi	r1, r1, 8
	.size	uart_getc, .-uart_getc
	.ident	"GCC: (GNU) 13.2.0"
