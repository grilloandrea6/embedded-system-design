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
	l.ori	r13, r13, 28612
	l.sw	32744(r1), r16
	l.sw	32748(r1), r18
	l.sw	32752(r1), r20
	l.sw	32756(r1), r22
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
	l.lwz	r18, 24(r1)
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
	l.sw	0(r1), r18
	l.jal	printf_
	l.addi	r3, r3, lo(.LC3)
	l.ori	r17, r0, 240
	l.sfgtu	r18, r17
	l.bf	.L3
	l.or	r17, r18, r18
	l.movhi	r17, hi(-2147483648)
	l.or	r17, r18, r17
.L3:
	l.sw	4(r1), r17
	l.lwz	r17, 4(r1)
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
	l.movhi	r20, hi(1342177280)
	l.ori	r19, r20, 36
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
	l.ori	r19, r20, 40
	l.sw	0(r19), r17
	l.movhi	r17, hi(-983040)
	l.movhi	r19, hi(917504)
	l.ori	r17, r17, 61440
	l.ori	r19, r19, 4132
	l.add	r19, r19, r17
	l.add	r17, r19, r1
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
	l.ori	r20, r20, 44
	l.sw	0(r20), r17
	l.ori	r17, r0, 3840
#  35 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.movhi	r17, hi(-655360)
	l.movhi	r19, hi(917504)
	l.ori	r20, r17, 40960
	l.ori	r19, r19, 4132
	l.add	r19, r19, r20
	l.add	r20, r19, r1
	l.movhi	r19, hi(917504)
	l.ori	r17, r17, 40964
	l.ori	r19, r19, 4132
	l.add	r19, r19, r17
	l.add	r22, r19, r1
	l.ori	r17, r0, 15
.L12:
#  41 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.jal	takeSingleImageBlocking
	l.or	r3, r20, r20
	l.movhi	r27, hi(-983040)
	l.movhi	r17, hi(0)
	l.movhi	r25, hi(0)
	l.ori	r27, r27, 61440
.L4:
	l.sfeq	r25, r18
	l.bf	.L6
	l.add	r23, r17, r17
	l.j	.L7
	l.movhi	r21, hi(0)
	l.j	.L3
	l.or	r17, r18, r18
.L5:
	l.lwz	r29, 0(r19)
	l.add	r19, r22, r23
	l.lwz	r19, 0(r19)
#  101 "src/grayscale.c" 1
	l.nios_rrr r29, r29, r19, 13
#  0 "" 2
	l.movhi	r19, hi(917504)
	l.ori	r19, r19, 4132
	l.add	r19, r19, r21
	l.add	r19, r19, r1
	l.add	r19, r19, r17
	l.add	r19, r19, r27
	l.sw	0(r19), r29
	l.addi	r21, r21, 4
	l.addi	r23, r23, 8
.L7:
	l.sfgtu	r16, r21
	l.bf	.L5
	l.add	r19, r20, r23
	l.addi	r25, r25, 1
	l.j	.L4
	l.add	r17, r17, r16
.L6:
	l.ori	r17, r0, 240
#  110 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.movhi	r17, hi(0)
#  113 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC6)
	l.sw	8(r1), r17
	l.lwz	r17, 8(r1)
	l.addi	r3, r3, lo(.LC6)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 1
#  116 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC7)
	l.sw	12(r1), r17
	l.lwz	r17, 12(r1)
	l.addi	r3, r3, lo(.LC7)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 2
#  119 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC8)
	l.sw	16(r1), r17
	l.lwz	r17, 16(r1)
	l.addi	r3, r3, lo(.LC8)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 3
#  122 "src/grayscale.c" 1
	l.nios_rrr r17, r17, r0, 0x8 
#  0 "" 2
	l.movhi	r3, ha(.LC9)
	l.sw	8(r1), r17
	l.lwz	r17, 8(r1)
	l.addi	r3, r3, lo(.LC9)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 3840
#  126 "src/grayscale.c" 1
	l.nios_rrr r0, r0, r17, 0x8
#  0 "" 2
	l.j	.L12
	l.ori	r17, r0, 15
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.0"
