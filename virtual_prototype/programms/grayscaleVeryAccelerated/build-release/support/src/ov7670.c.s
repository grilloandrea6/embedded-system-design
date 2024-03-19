	.file	"ov7670.c"
	.section	.text
	.align 4
	.global	readOv7670Register
	.type	readOv7670Register, @function
readOv7670Register:
	l.ori	r17, r0, 8
	l.sll	r3, r3, r17
	l.andi	r3, r3, 65535
	l.movhi	r17, hi(1124073472)
	l.or	r3, r3, r17
#  340 "support/src/ov7670.c" 1
	l.nios_rrc r11,r3,r0,0x5
#  0 "" 2
	l.movhi	r17, hi(0)
	l.sfges	r11, r17
	l.bf	.L1
	 l.nop

#  340 "support/src/ov7670.c" 1
	l.nios_rrc r11,r3,r0,0x5
#  0 "" 2
	l.sfges	r11, r17
	l.bf	.L1
	 l.nop

#  340 "support/src/ov7670.c" 1
	l.nios_rrc r11,r3,r0,0x5
#  0 "" 2
	l.sfges	r11, r17
	l.bf	.L1
	 l.nop

#  340 "support/src/ov7670.c" 1
	l.nios_rrc r11,r3,r0,0x5
#  0 "" 2
.L1:
	l.jr	r9
	 l.nop

	.size	readOv7670Register, .-readOv7670Register
	.align 4
	.global	writeOv7670Register
	.type	writeOv7670Register, @function
writeOv7670Register:
	l.ori	r17, r0, 8
	l.sll	r3, r3, r17
	l.andi	r4, r4, 0xff
	l.andi	r3, r3, 65535
	l.or	r3, r3, r4
	l.movhi	r17, hi(1107296256)
	l.or	r3, r3, r17
#  348 "support/src/ov7670.c" 1
	l.nios_rrc r0,r3,r0,0x5
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	writeOv7670Register, .-writeOv7670Register
	.align 4
	.global	writeRegisterList
	.type	writeRegisterList, @function
writeRegisterList:
	l.addi	r1, r1, -12
	l.sw	0(r1), r16
	l.sw	4(r1), r18
	l.sw	8(r1), r9
	l.or	r16, r3, r3
	l.ori	r18, r0, 255
	l.lbz	r3, 0(r16)
.L8:
	l.lbz	r4, 1(r16)
	l.and	r17, r3, r4
	l.sfeq	r17, r18
	l.bf	.L4
	l.lwz	r9, 8(r1)
	l.jal	writeOv7670Register
	l.addi	r16, r16, 2
	l.j	.L8
	l.lbz	r3, 0(r16)
.L4:
	l.lwz	r16, 0(r1)
	l.lwz	r18, 4(r1)
	l.jr	r9
	l.addi	r1, r1, 12
	.size	writeRegisterList, .-writeRegisterList
	.align 4
	.global	initOv7670
	.type	initOv7670, @function
initOv7670:
	l.addi	r1, r1, -16
	l.movhi	r17, hi(1107296256)
	l.sw	0(r1), r16
	l.sw	8(r1), r20
	l.sw	4(r1), r18
	l.sw	12(r1), r9
	l.or	r16, r3, r3
	l.or	r20, r4, r4
	l.ori	r17, r17, 4736
#  348 "support/src/ov7670.c" 1
	l.nios_rrc r0,r17,r0,0x5
#  0 "" 2
	l.movhi	r17, hi(65536)
	l.ori	r17, r17, 34464
#  366 "support/src/ov7670.c" 1
	l.nios_rrc r0,r17,r0,0x6
#  0 "" 2
	l.movhi	r18, ha(.LANCHOR0)
	l.addi	r18, r18, lo(.LANCHOR0)
	l.jal	writeRegisterList
	l.or	r3, r18, r18
	l.ori	r17, r0, 1
	l.sfeq	r20, r17
	l.bf	.L10
	l.ori	r17, r0, 2
	l.sfne	r20, r17
	l.bf	.L11
	 l.nop

	l.addi	r3, r18, 312
.L14:
	l.jal	writeRegisterList
	 l.nop

	l.jal	writeRegisterList
	l.addi	r3, r18, 372
	l.movhi	r17, hi(1107296256)
	l.ori	r17, r17, 4352
#  348 "support/src/ov7670.c" 1
	l.nios_rrc r0,r17,r0,0x5
#  0 "" 2
	l.movhi	r17, hi(1966080)
	l.ori	r17, r17, 33920
#  377 "support/src/ov7670.c" 1
	l.nios_rrc r0,r17,r0,0x6
#  0 "" 2
	l.movhi	r17, hi(0)
#  378 "support/src/ov7670.c" 1
	l.nios_rrc r17,r17,r0,0x7
#  0 "" 2
	l.ori	r23, r0, 1
#  380 "support/src/ov7670.c" 1
	l.nios_rrc r23,r23,r0,0x7
#  0 "" 2
	l.ori	r21, r0, 2
#  381 "support/src/ov7670.c" 1
	l.nios_rrc r21,r21,r0,0x7
#  0 "" 2
	l.ori	r19, r0, 3
#  382 "support/src/ov7670.c" 1
	l.nios_rrc r19,r19,r0,0x7
#  0 "" 2
	l.ori	r25, r0, 1
	l.srl	r17, r17, r25
	l.sw	0(r16), r17
	l.sw	4(r16), r23
	l.sw	8(r16), r21
	l.sw	12(r16), r19
	l.or	r11, r16, r16
	l.lwz	r18, 4(r1)
	l.lwz	r16, 0(r1)
	l.lwz	r20, 8(r1)
	l.lwz	r9, 12(r1)
	l.jr	r9
	l.addi	r1, r1, 16
.L10:
	l.j	.L14
	l.addi	r3, r18, 334
.L11:
	l.j	.L14
	l.addi	r3, r18, 356
	.size	initOv7670, .-initOv7670
	.align 4
	.global	takeSingleImageBlocking
	.type	takeSingleImageBlocking, @function
takeSingleImageBlocking:
	l.ori	r17, r0, 5
#  388 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r3,0x7
#  0 "" 2
	l.ori	r17, r0, 6
	l.ori	r19, r0, 2
#  389 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r19,0x7
#  0 "" 2
	l.ori	r19, r0, 7
.L16:
#  391 "support/src/ov7670.c" 1
	l.nios_rrc r17,r19,r0,0x7
#  0 "" 2
	l.movhi	r21, hi(0)
	l.sfeq	r17, r21
	l.bf	.L16
	 l.nop

	l.jr	r9
	 l.nop

	.size	takeSingleImageBlocking, .-takeSingleImageBlocking
	.align 4
	.global	takeSingleImageNonBlocking
	.type	takeSingleImageNonBlocking, @function
takeSingleImageNonBlocking:
	l.ori	r17, r0, 5
#  396 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r3,0x7
#  0 "" 2
	l.ori	r17, r0, 6
	l.ori	r19, r0, 2
#  397 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r19,0x7
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	takeSingleImageNonBlocking, .-takeSingleImageNonBlocking
	.align 4
	.global	waitForNextImage
	.type	waitForNextImage, @function
waitForNextImage:
	l.ori	r19, r0, 7
.L21:
#  403 "support/src/ov7670.c" 1
	l.nios_rrc r17,r19,r0,0x7
#  0 "" 2
	l.movhi	r21, hi(0)
	l.sfeq	r17, r21
	l.bf	.L21
	 l.nop

	l.jr	r9
	 l.nop

	.size	waitForNextImage, .-waitForNextImage
	.align 4
	.global	enableContinues
	.type	enableContinues, @function
enableContinues:
	l.ori	r17, r0, 5
#  407 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r3,0x7
#  0 "" 2
	l.ori	r17, r0, 6
	l.ori	r19, r0, 1
#  408 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r19,0x7
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	enableContinues, .-enableContinues
	.align 4
	.global	disableContinues
	.type	disableContinues, @function
disableContinues:
	l.ori	r17, r0, 6
	l.movhi	r19, hi(0)
#  412 "support/src/ov7670.c" 1
	l.nios_rrr r0,r17,r19,0x7
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	disableContinues, .-disableContinues
	.global	rgb565_ov7670
	.global	qqvga_ov7670
	.global	qvga_ov7670
	.global	vga_ov7670
	.global	ov7670_default_regs
	.section	.rodata
	.set	.LANCHOR0,. + 0
	.type	ov7670_default_regs, @object
	.size	ov7670_default_regs, 312
ov7670_default_regs:
	.byte	58
	.byte	4
	.byte	18
	.byte	0
	.byte	23
	.byte	19
	.byte	24
	.byte	1
	.byte	50
	.byte	-74
	.byte	25
	.byte	2
	.byte	26
	.byte	122
	.byte	3
	.byte	10
	.byte	12
	.byte	0
	.byte	62
	.byte	0
	.byte	112
	.byte	58
	.byte	113
	.byte	53
	.byte	114
	.byte	17
	.byte	115
	.byte	-16
	.byte	-94
	.byte	1
	.byte	21
	.byte	2
	.byte	122
	.byte	32
	.byte	123
	.byte	16
	.byte	124
	.byte	30
	.byte	125
	.byte	53
	.byte	126
	.byte	90
	.byte	127
	.byte	105
	.byte	-128
	.byte	118
	.byte	-127
	.byte	-128
	.byte	-126
	.byte	-120
	.byte	-125
	.byte	-113
	.byte	-124
	.byte	-106
	.byte	-123
	.byte	-93
	.byte	-122
	.byte	-81
	.byte	-121
	.byte	-60
	.byte	-120
	.byte	-41
	.byte	-119
	.byte	-24
	.byte	19
	.byte	-64
	.byte	0
	.byte	0
	.byte	16
	.byte	0
	.byte	13
	.byte	64
	.byte	20
	.byte	24
	.byte	-91
	.byte	5
	.byte	-85
	.byte	7
	.byte	36
	.byte	-107
	.byte	37
	.byte	51
	.byte	38
	.byte	-29
	.byte	-97
	.byte	120
	.byte	-96
	.byte	104
	.byte	-95
	.byte	3
	.byte	-90
	.byte	-40
	.byte	-89
	.byte	-40
	.byte	-88
	.byte	-16
	.byte	-87
	.byte	-112
	.byte	-86
	.byte	-108
	.byte	19
	.byte	-59
	.byte	48
	.byte	0
	.byte	49
	.byte	0
	.byte	14
	.byte	97
	.byte	15
	.byte	75
	.byte	22
	.byte	2
	.byte	30
	.byte	7
	.byte	33
	.byte	2
	.byte	34
	.byte	-111
	.byte	41
	.byte	7
	.byte	51
	.byte	11
	.byte	53
	.byte	11
	.byte	55
	.byte	29
	.byte	56
	.byte	113
	.byte	57
	.byte	42
	.byte	60
	.byte	120
	.byte	77
	.byte	64
	.byte	78
	.byte	32
	.byte	105
	.byte	0
	.byte	116
	.byte	16
	.byte	-115
	.byte	79
	.byte	-114
	.byte	0
	.byte	-113
	.byte	0
	.byte	-112
	.byte	0
	.byte	-111
	.byte	0
	.byte	-106
	.byte	0
	.byte	-102
	.byte	0
	.byte	-80
	.byte	-124
	.byte	-79
	.byte	12
	.byte	-78
	.byte	14
	.byte	-77
	.byte	-126
	.byte	-72
	.byte	10
	.byte	67
	.byte	10
	.byte	68
	.byte	-16
	.byte	69
	.byte	52
	.byte	70
	.byte	88
	.byte	71
	.byte	40
	.byte	72
	.byte	58
	.byte	89
	.byte	-120
	.byte	90
	.byte	-120
	.byte	91
	.byte	68
	.byte	92
	.byte	103
	.byte	93
	.byte	73
	.byte	94
	.byte	14
	.byte	108
	.byte	10
	.byte	109
	.byte	85
	.byte	110
	.byte	17
	.byte	111
	.byte	-97
	.byte	106
	.byte	64
	.byte	1
	.byte	64
	.byte	2
	.byte	96
	.byte	19
	.byte	-57
	.byte	79
	.byte	-128
	.byte	80
	.byte	-128
	.byte	81
	.byte	0
	.byte	82
	.byte	34
	.byte	83
	.byte	94
	.byte	84
	.byte	-128
	.byte	88
	.byte	-98
	.byte	65
	.byte	8
	.byte	63
	.byte	0
	.byte	117
	.byte	5
	.byte	118
	.byte	-31
	.byte	76
	.byte	0
	.byte	119
	.byte	1
	.byte	61
	.byte	72
	.byte	75
	.byte	9
	.byte	-55
	.byte	96
	.byte	86
	.byte	64
	.byte	52
	.byte	17
	.byte	59
	.byte	18
	.byte	-92
	.byte	-126
	.byte	-106
	.byte	0
	.byte	-105
	.byte	48
	.byte	-104
	.byte	32
	.byte	-103
	.byte	48
	.byte	-102
	.byte	-124
	.byte	-101
	.byte	41
	.byte	-100
	.byte	3
	.byte	-99
	.byte	76
	.byte	-98
	.byte	63
	.byte	120
	.byte	4
	.byte	121
	.byte	1
	.byte	-56
	.byte	-16
	.byte	121
	.byte	15
	.byte	-56
	.byte	0
	.byte	121
	.byte	16
	.byte	-56
	.byte	126
	.byte	121
	.byte	10
	.byte	-56
	.byte	-128
	.byte	121
	.byte	11
	.byte	-56
	.byte	1
	.byte	121
	.byte	12
	.byte	-56
	.byte	15
	.byte	121
	.byte	13
	.byte	-56
	.byte	32
	.byte	121
	.byte	9
	.byte	-56
	.byte	-128
	.byte	121
	.byte	2
	.byte	-56
	.byte	-64
	.byte	121
	.byte	3
	.byte	-56
	.byte	64
	.byte	121
	.byte	5
	.byte	-56
	.byte	48
	.byte	121
	.byte	38
	.byte	-1
	.byte	-1
	.type	qqvga_ov7670, @object
	.size	qqvga_ov7670, 22
qqvga_ov7670:
	.byte	12
	.byte	4
	.byte	62
	.byte	26
	.byte	114
	.byte	34
	.byte	115
	.byte	-14
	.byte	23
	.byte	22
	.byte	24
	.byte	4
	.byte	50
	.byte	-92
	.byte	25
	.byte	2
	.byte	26
	.byte	122
	.byte	3
	.byte	10
	.byte	-1
	.byte	-1
	.type	qvga_ov7670, @object
	.size	qvga_ov7670, 22
qvga_ov7670:
	.byte	12
	.byte	4
	.byte	62
	.byte	25
	.byte	114
	.byte	17
	.byte	115
	.byte	-15
	.byte	23
	.byte	22
	.byte	24
	.byte	4
	.byte	50
	.byte	36
	.byte	25
	.byte	2
	.byte	26
	.byte	122
	.byte	3
	.byte	10
	.byte	-1
	.byte	-1
	.type	vga_ov7670, @object
	.size	vga_ov7670, 16
vga_ov7670:
	.byte	12
	.byte	0
	.byte	50
	.byte	-10
	.byte	23
	.byte	19
	.byte	24
	.byte	1
	.byte	25
	.byte	2
	.byte	26
	.byte	122
	.byte	3
	.byte	10
	.byte	-1
	.byte	-1
	.type	rgb565_ov7670, @object
	.size	rgb565_ov7670, 26
rgb565_ov7670:
	.byte	18
	.byte	4
	.byte	-116
	.byte	0
	.byte	4
	.byte	0
	.byte	64
	.byte	-48
	.byte	20
	.byte	106
	.byte	79
	.byte	-77
	.byte	80
	.byte	-77
	.byte	81
	.byte	0
	.byte	82
	.byte	61
	.byte	83
	.byte	-89
	.byte	84
	.byte	-28
	.byte	61
	.byte	64
	.byte	-1
	.byte	-1
	.ident	"GCC: (GNU) 13.2.0"
