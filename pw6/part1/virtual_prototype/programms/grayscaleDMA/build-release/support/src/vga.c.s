	.file	"vga.c"
	.section	.text
	.align 4
	.global	vga_clear
	.type	vga_clear, @function
vga_clear:
	l.ori	r17, r0, 3
#  10 "support/src/vga.c" 1
	l.nios_crr r0,r17,r0,0x0
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	vga_clear, .-vga_clear
	.align 4
	.global	vga_textcorr
	.type	vga_textcorr, @function
vga_textcorr:
	l.ori	r17, r0, 6
#  14 "support/src/vga.c" 1
	l.nios_crr r0,r17,r3,0x0
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	vga_textcorr, .-vga_textcorr
	.align 4
	.global	vga_putc
	.type	vga_putc, @function
vga_putc:
	l.ori	r17, r0, 2
#  18 "support/src/vga.c" 1
	l.nios_crr r0,r17,r3,0x0
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	vga_putc, .-vga_putc
	.align 4
	.global	vga_puts
	.type	vga_puts, @function
vga_puts:
	l.ori	r19, r0, 2
	l.lbs	r17, 0(r3)
.L7:
	l.movhi	r21, hi(0)
	l.sfne	r17, r21
	l.bf	.L6
	 l.nop

	l.jr	r9
	 l.nop

.L6:
	l.addi	r3, r3, 1
#  18 "support/src/vga.c" 1
	l.nios_crr r0,r19,r17,0x0
#  0 "" 2
	l.j	.L7
	l.lbs	r17, 0(r3)
	.size	vga_puts, .-vga_puts
	.ident	"GCC: (GNU) 13.2.0"
