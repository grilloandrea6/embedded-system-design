	.file	"grayscale.c"
	.section	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Initialising camera (this takes up to 3 seconds)!\n"
.LC1:
	.string	"Done!\n"
.LC2:
	.string	"NrOfPixels : %d\n"
.LC3:
	.string	"NrOfLines  : %d\n"
.LC4:
	.string	"PCLK (kHz) : %d\n"
.LC5:
	.string	"FPS        : %d\n"
.LC6:
	.string	"CPU cycles\t:\t %u\n"
.LC7:
	.string	"Stall cycles\t:\t %u\n"
.LC8:
	.string	"Bus idle\t:\t %u\n"
.LC9:
	.string	"CPU cycles\t:\t %u\n\n"
	.section	.text.startup,"ax",@progbits
	.align 4
	.global	main
	.type	main, @function
main:
	l.addi	r1, r1, -32764
	l.movhi	r13, hi(-917504)
	l.sw	32760(r1), r9
	l.ori	r13, r13, 28608
	l.sw	32740(r1), r16
	l.sw	32748(r1), r20
	l.sw	32744(r1), r18
	l.sw	32752(r1), r22
	l.sw	32756(r1), r24
	l.jal	vga_clear
	l.add	r1, r1, r13
	l.movhi	r3, ha(.LC0)
	l.jal	printf_
	l.addi	r3, r3, lo(.LC0)
	l.movhi	r3, hi(-983040)
	l.movhi	r17, hi(917504)
	l.ori	r3, r3, 61424
	l.ori	r17, r17, 4132
	l.add	r17, r17, r3
	l.add	r3, r17, r1
	l.jal	initOv7670
	l.movhi	r4, hi(0)
	l.movhi	r3, ha(.LC1)
	l.addi	r3, r3, lo(.LC1)
	l.lwz	r16, 20(r1)
	l.jal	printf_
	l.lwz	r20, 24(r1)
	l.movhi	r3, ha(.LC2)
	l.sw	0(r1), r16
	l.jal	printf_
	l.addi	r3, r3, lo(.LC2)
	l.ori	r17, r0, 320
	l.sfgtu	r16, r17
	l.bf	.L2
	l.or	r17, r16, r16
	l.movhi	r17, hi(-2147483648)
	l.or	r17, r16, r17
.L2:
	l.sw	4(r1), r17
	l.lwz	r19, 4(r1)
#  12 "support/include/swap.h" 1
	l.nios_rrr r19,r19,r0,0x1
#  0 "" 2
	l.movhi	r17, hi(1342177280)
	l.ori	r17, r17, 32
	l.sw	0(r17), r19
	l.movhi	r3, ha(.LC3)
	l.sw	0(r1), r20
	l.jal	printf_
	l.addi	r3, r3, lo(.LC3)
	l.ori	r17, r0, 240
	l.sfgtu	r20, r17
	l.bf	.L3
	l.or	r17, r20, r20
	l.movhi	r17, hi(-2147483648)
	l.or	r17, r20, r17
.L3:
	l.sw	4(r1), r17
	l.lwz	r17, 4(r1)
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
	l.movhi	r22, hi(1342177280)
	l.ori	r19, r22, 36
	l.sw	0(r19), r17
	l.movhi	r3, ha(.LC4)
	l.lwz	r17, 28(r1)
	l.addi	r3, r3, lo(.LC4)
	l.jal	printf_
	l.sw	0(r1), r17
	l.movhi	r3, ha(.LC5)
	l.lwz	r17, 32(r1)
	l.addi	r3, r3, lo(.LC5)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 2
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
	l.ori	r19, r22, 40
	l.sw	0(r19), r17
	l.movhi	r18, hi(-983040)
	l.movhi	r17, hi(917504)
	l.ori	r18, r18, 61440
	l.ori	r17, r17, 4132
	l.add	r17, r17, r18
	l.add	r18, r17, r1
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r18,r0,0x1
#  0 "" 2
	l.ori	r22, r22, 44
	l.sw	0(r22), r17
	l.ori	r17, r0, 3840
#  34 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.movhi	r24, hi(-655360)
	l.movhi	r17, hi(917504)
	l.ori	r24, r24, 40960
	l.ori	r17, r17, 4132
	l.add	r17, r17, r24
	l.add	r22, r17, r1
	l.ori	r17, r0, 15
.L12:
#  40 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.jal	takeSingleImageBlocking
	l.or	r3, r22, r22
	l.movhi	r27, hi(0)
	l.movhi	r25, hi(0)
	l.ori	r23, r0, 1
.L4:
	l.sfne	r25, r20
	l.bf	.L10
	l.or	r19, r27, r27
	l.ori	r17, r0, 240
#  61 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.movhi	r17, hi(0)
#  64 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC6)
	l.sw	8(r1), r17
	l.lwz	r17, 8(r1)
	l.addi	r3, r3, lo(.LC6)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 1
#  67 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC7)
	l.sw	12(r1), r17
	l.lwz	r17, 12(r1)
	l.addi	r3, r3, lo(.LC7)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 2
#  70 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC8)
	l.sw	16(r1), r17
	l.lwz	r17, 16(r1)
	l.addi	r3, r3, lo(.LC8)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 3
#  73 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC9)
	l.sw	8(r1), r17
	l.lwz	r17, 8(r1)
	l.addi	r3, r3, lo(.LC9)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 3840
#  77 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.j	.L12
	l.ori	r17, r0, 15
	l.j	.L3
	l.or	r17, r20, r20
.L5:
	l.add	r17, r19, r19
	l.ori	r21, r21, 4132
	l.add	r21, r21, r17
	l.add	r17, r21, r1
	l.add	r17, r17, r24
	l.lhz	r31, 0(r17)
#  18 "support/include/swap.h" 1
	l.nios_rrr r31,r31,r23,0x1
#  0 "" 2
	l.movhi	r21, hi(917504)
	l.addi	r17, r19, 1
	l.add	r17, r17, r17
	l.ori	r21, r21, 4132
	l.add	r21, r21, r17
	l.add	r17, r21, r1
	l.add	r17, r17, r24
	l.andi	r31, r31, 0xffff
	l.lhz	r17, 0(r17)
#  18 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r23,0x1
#  0 "" 2
	l.movhi	r13, hi(917504)
	l.addi	r21, r19, 2
	l.add	r21, r21, r21
	l.ori	r13, r13, 4132
	l.add	r13, r13, r21
	l.add	r21, r13, r1
	l.add	r21, r21, r24
	l.andi	r17, r17, 0xffff
	l.lhz	r13, 0(r21)
#  18 "support/include/swap.h" 1
	l.nios_rrr r13,r13,r23,0x1
#  0 "" 2
	l.movhi	r15, hi(917504)
	l.addi	r21, r19, 3
	l.add	r21, r21, r21
	l.ori	r15, r15, 4132
	l.add	r15, r15, r21
	l.add	r21, r15, r1
	l.add	r21, r21, r24
	l.andi	r13, r13, 0xffff
	l.lhz	r21, 0(r21)
#  18 "support/include/swap.h" 1
	l.nios_rrr r21,r21,r23,0x1
#  0 "" 2
	l.ori	r15, r0, 16
	l.sll	r17, r17, r15
	l.sll	r21, r21, r15
	l.or	r17, r17, r31
	l.or	r21, r21, r13
#  54 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r21, 13
#  0 "" 2
	l.add	r21, r18, r19
	l.sw	0(r21), r17
	l.addi	r29, r29, 4
	l.addi	r19, r19, 4
.L6:
	l.sfgtu	r16, r29
	l.bf	.L5
	l.movhi	r21, hi(917504)
	l.addi	r25, r25, 1
	l.j	.L4
	l.add	r27, r27, r16
.L10:
	l.j	.L6
	l.movhi	r29, hi(0)
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.0"
