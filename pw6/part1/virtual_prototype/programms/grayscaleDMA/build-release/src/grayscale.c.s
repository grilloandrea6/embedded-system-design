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
	.string	"nrOfCycles: %d %d %d\n"
	.section	.text.startup,"ax",@progbits
	.align 4
	.global	main
	.type	main, @function
main:
	l.addi	r1, r1, -32764
	l.movhi	r13, hi(-917504)
	l.sw	32760(r1), r9
	l.ori	r13, r13, 28596
	l.sw	32752(r1), r16
	l.sw	32756(r1), r18
	l.jal	vga_clear
	l.add	r1, r1, r13
	l.movhi	r3, ha(.LC0)
	l.jal	printf_
	l.addi	r3, r3, lo(.LC0)
	l.movhi	r3, hi(-983040)
	l.movhi	r17, hi(917504)
	l.ori	r3, r3, 61424
	l.ori	r17, r17, 4156
	l.add	r17, r17, r3
	l.add	r3, r17, r1
	l.jal	initOv7670
	l.movhi	r4, hi(0)
	l.movhi	r3, ha(.LC1)
	l.addi	r3, r3, lo(.LC1)
	l.lwz	r18, 44(r1)
	l.jal	printf_
	l.lwz	r16, 48(r1)
	l.movhi	r3, ha(.LC2)
	l.sw	0(r1), r18
	l.jal	printf_
	l.addi	r3, r3, lo(.LC2)
	l.ori	r17, r0, 320
	l.sfgtu	r18, r17
	l.bf	.L2
	l.movhi	r17, hi(-2147483648)
	l.or	r18, r18, r17
.L2:
	l.sw	16(r1), r18
	l.lwz	r19, 16(r1)
#  12 "support/include/swap.h" 1
	l.nios_rrr r19,r19,r0,0x1
#  0 "" 2
	l.movhi	r17, hi(1342177280)
	l.ori	r17, r17, 32
	l.sw	0(r17), r19
	l.movhi	r3, ha(.LC3)
	l.sw	0(r1), r16
	l.jal	printf_
	l.addi	r3, r3, lo(.LC3)
	l.ori	r17, r0, 240
	l.sfgtu	r16, r17
	l.bf	.L3
	l.movhi	r17, hi(-2147483648)
	l.or	r16, r16, r17
.L3:
	l.sw	16(r1), r16
	l.lwz	r17, 16(r1)
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
	l.movhi	r16, hi(1342177280)
	l.ori	r19, r16, 36
	l.sw	0(r19), r17
	l.movhi	r3, ha(.LC4)
	l.lwz	r17, 52(r1)
	l.addi	r3, r3, lo(.LC4)
	l.jal	printf_
	l.sw	0(r1), r17
	l.movhi	r3, ha(.LC5)
	l.lwz	r17, 56(r1)
	l.addi	r3, r3, lo(.LC5)
	l.jal	printf_
	l.sw	0(r1), r17
	l.ori	r17, r0, 2
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
	l.ori	r19, r16, 40
	l.sw	0(r19), r17
	l.movhi	r18, hi(-983040)
	l.movhi	r17, hi(917504)
	l.ori	r18, r18, 61440
	l.ori	r17, r17, 4156
	l.add	r17, r17, r18
	l.add	r18, r17, r1
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r18,r0,0x1
#  0 "" 2
	l.ori	r16, r16, 44
	l.sw	0(r16), r17
	l.ori	r19, r0, 31
	l.ori	r17, r0, 4608
#  33 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r19, 20
#  0 "" 2
	l.movhi	r16, hi(-655360)
	l.sw	12(r1), r17
	l.movhi	r17, hi(917504)
	l.ori	r16, r16, 40960
	l.ori	r17, r17, 4156
	l.add	r17, r17, r16
	l.add	r16, r17, r1
.L13:
	l.jal	takeSingleImageBlocking
	l.or	r3, r16, r16
	l.ori	r17, r0, 7
#  41 "src/grayscale.c" 1
	l.nios_rrr r0,r0,r17,0xC
#  0 "" 2
	l.ori	r17, r0, 1536
#  47 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r16, 20
#  0 "" 2
	l.movhi	r19, hi(0)
	l.sw	12(r1), r17
	l.ori	r17, r0, 2560
#  49 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r19, 20
#  0 "" 2
	l.ori	r19, r0, 256
	l.sw	12(r1), r17
	l.ori	r17, r0, 3584
#  51 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r19, 20
#  0 "" 2
	l.ori	r21, r0, 5120
	l.sw	12(r1), r17
	l.ori	r19, r0, 1
.L4:
#  55 "src/grayscale.c" 1
	l.nios_rrr r17,r21,r19, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.movhi	r23, hi(0)
	l.lwz	r17, 12(r1)
	l.andi	r17, r17, 1
	l.sfne	r17, r23
	l.bf	.L4
	l.ori	r17, r0, 5632
#  60 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r19, 20
#  0 "" 2
	l.ori	r19, r0, 5120
	l.sw	12(r1), r17
	l.ori	r21, r0, 1
.L5:
#  64 "src/grayscale.c" 1
	l.nios_rrr r17,r19,r21, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.movhi	r23, hi(0)
	l.lwz	r17, 12(r1)
	l.andi	r17, r17, 1
	l.sfne	r17, r23
	l.bf	.L5
	 l.nop

	l.sw	32(r1), r0
	l.ori	r21, r0, 599
	l.ori	r23, r0, 1536
	l.ori	r25, r0, 2560
	l.ori	r27, r0, 3584
	l.ori	r15, r0, 256
	l.ori	r29, r0, 5632
	l.ori	r19, r0, 1
	l.movhi	r31, hi(0)
	l.ori	r12, r0, 255
	l.ori	r13, r0, 5120
	l.ori	r11, r0, 128
	l.ori	r8, r0, 2
.L6:
	l.lwz	r17, 32(r1)
	l.sfles	r17, r21
	l.bf	.L12
	l.ori	r17, r0, 368
#  128 "src/grayscale.c" 1
	l.nios_rrr r17,r0,r17,0xC
#  0 "" 2
	l.ori	r19, r0, 512
	l.sw	20(r1), r17
	l.ori	r17, r0, 1
#  129 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r19,0xC
#  0 "" 2
	l.ori	r19, r0, 1024
	l.sw	24(r1), r17
	l.ori	r17, r0, 2
#  130 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r19,0xC
#  0 "" 2
	l.movhi	r3, ha(.LC6)
	l.sw	28(r1), r17
	l.lwz	r17, 20(r1)
	l.addi	r3, r3, lo(.LC6)
	l.lwz	r19, 24(r1)
	l.sw	0(r1), r17
	l.lwz	r21, 28(r1)
	l.sw	4(r1), r19
	l.jal	printf_
	l.sw	8(r1), r21
	l.j	.L13
	 l.nop

.L12:
	l.lwz	r17, 32(r1)
	l.lwz	r7, 32(r1)
	l.sfeq	r7, r21
	l.bf	.L7
	l.ori	r7, r0, 10
	l.addi	r17, r17, 1
	l.sll	r17, r17, r7
	l.add	r17, r16, r17
#  77 "src/grayscale.c" 1
	l.nios_rrr r17,r23,r17, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.lwz	r17, 32(r1)
	l.xori	r17, r17, -1
	l.ori	r7, r0, 8
	l.andi	r17, r17, 1
	l.sll	r17, r17, r7
#  79 "src/grayscale.c" 1
	l.nios_rrr r17,r25,r17, 20
#  0 "" 2
	l.sw	12(r1), r17
#  82 "src/grayscale.c" 1
	l.nios_rrr r17,r27,r15, 20
#  0 "" 2
	l.sw	12(r1), r17
#  85 "src/grayscale.c" 1
	l.nios_rrr r17,r29,r19, 20
#  0 "" 2
	l.sw	12(r1), r17
.L7:
	l.sw	36(r1), r0
	l.sw	40(r1), r0
.L8:
	l.lwz	r17, 36(r1)
	l.sfles	r17, r12
	l.bf	.L9
	 l.nop

.L10:
#  104 "src/grayscale.c" 1
	l.nios_rrr r17,r13,r19, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.movhi	r7, hi(0)
	l.lwz	r17, 12(r1)
	l.andi	r17, r17, 1
	l.sfne	r17, r7
	l.bf	.L10
	l.ori	r7, r0, 9
	l.lwz	r17, 32(r1)
	l.sll	r17, r17, r7
	l.add	r17, r18, r17
#  111 "src/grayscale.c" 1
	l.nios_rrr r17,r23,r17, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.ori	r7, r0, 8
	l.lwz	r17, 32(r1)
	l.andi	r17, r17, 1
	l.sll	r17, r17, r7
#  114 "src/grayscale.c" 1
	l.nios_rrr r17,r25,r17, 20
#  0 "" 2
	l.sw	12(r1), r17
#  116 "src/grayscale.c" 1
	l.nios_rrr r17,r27,r11, 20
#  0 "" 2
	l.sw	12(r1), r17
#  118 "src/grayscale.c" 1
	l.nios_rrr r17,r29,r8, 20
#  0 "" 2
	l.sw	12(r1), r17
.L11:
#  122 "src/grayscale.c" 1
	l.nios_rrr r17,r13,r19, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.movhi	r7, hi(0)
	l.lwz	r17, 12(r1)
	l.andi	r17, r17, 1
	l.sfne	r17, r7
	l.bf	.L11
	 l.nop

	l.lwz	r17, 32(r1)
	l.addi	r17, r17, 1
	l.sw	32(r1), r17
	l.j	.L6
	 l.nop

.L9:
	l.lwz	r6, 32(r1)
	l.ori	r17, r0, 8
	l.andi	r6, r6, 1
	l.sll	r6, r6, r17
	l.lwz	r7, 36(r1)
	l.add	r7, r7, r6
#  92 "src/grayscale.c" 1
	l.nios_rrr r7,r7,r31, 20
#  0 "" 2
	l.lwz	r17, 36(r1)
	l.add	r17, r17, r6
	l.addi	r17, r17, 1
#  93 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r31, 20
#  0 "" 2
#  12 "support/include/swap.h" 1
	l.nios_rrr r17,r17,r0,0x1
#  0 "" 2
#  12 "support/include/swap.h" 1
	l.nios_rrr r7,r7,r0,0x1
#  0 "" 2
#  96 "src/grayscale.c" 1
	l.nios_rrr r17,r17,r7,0x9
#  0 "" 2
	l.lwz	r7, 40(r1)
	l.add	r7, r7, r6
	l.ori	r7, r7, 512
#  99 "src/grayscale.c" 1
	l.nios_rrr r17,r7,r17, 20
#  0 "" 2
	l.sw	12(r1), r17
	l.lwz	r17, 36(r1)
	l.addi	r17, r17, 2
	l.sw	36(r1), r17
	l.lwz	r17, 40(r1)
	l.addi	r17, r17, 1
	l.sw	40(r1), r17
	l.j	.L8
	 l.nop

	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.0"
