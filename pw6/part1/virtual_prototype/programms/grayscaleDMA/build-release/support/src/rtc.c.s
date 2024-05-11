	.file	"rtc.c"
	.section	.text
	.align 4
	.global	readRtcRegister
	.type	readRtcRegister, @function
readRtcRegister:
	l.ori	r17, r0, 8
	l.sll	r3, r3, r17
	l.addi	r1, r1, -12
	l.andi	r3, r3, 65535
	l.movhi	r17, hi(-788529152)
	l.sw	8(r1), r0
	l.or	r3, r3, r17
	l.sw	0(r1), r3
	l.ori	r19, r0, 3
.L3:
	l.lwz	r17, 0(r1)
#  12 "support/src/rtc.c" 1
	l.nios_rrc r17,r17,r0,0x5
#  0 "" 2
	l.sw	4(r1), r17
	l.lwz	r17, 8(r1)
	l.addi	r17, r17, 1
	l.sw	8(r1), r17
	l.lwz	r17, 8(r1)
	l.sfgts	r17, r19
	l.bf	.L2
	l.movhi	r21, hi(0)
	l.lwz	r17, 4(r1)
	l.sflts	r17, r21
	l.bf	.L3
	 l.nop

.L2:
	l.lwz	r11, 4(r1)
	l.jr	r9
	l.addi	r1, r1, 12
	.size	readRtcRegister, .-readRtcRegister
	.align 4
	.global	writeRtcRegister
	.type	writeRtcRegister, @function
writeRtcRegister:
	l.ori	r17, r0, 8
	l.sll	r3, r3, r17
	l.andi	r4, r4, 0xff
	l.andi	r3, r3, 65535
	l.or	r3, r3, r4
	l.movhi	r17, hi(-805306368)
	l.or	r3, r3, r17
#  20 "support/src/rtc.c" 1
	l.nios_rrc r0,r3,r0,0x5
#  0 "" 2
	l.jr	r9
	 l.nop

	.size	writeRtcRegister, .-writeRtcRegister
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%02X-%02X-20%02X %02X:%02X:%02X\n"
	.section	.text
	.align 4
	.global	printTimeComplete
	.type	printTimeComplete, @function
printTimeComplete:
	l.addi	r1, r1, -68
	l.movhi	r3, hi(0)
	l.sw	32(r1), r18
	l.sw	36(r1), r20
	l.sw	40(r1), r22
	l.sw	44(r1), r24
	l.sw	48(r1), r26
	l.sw	52(r1), r28
	l.sw	24(r1), r14
	l.sw	28(r1), r16
	l.sw	56(r1), r30
	l.sw	60(r1), r2
	l.sw	64(r1), r9
	l.jal	readRtcRegister
	l.movhi	r20, ha(.LC0)
	l.or	r18, r11, r11
	l.ori	r28, r0, 4
	l.ori	r26, r0, 5
	l.ori	r24, r0, 6
	l.ori	r22, r0, 2
	l.addi	r20, r20, lo(.LC0)
.L8:
	l.jal	readRtcRegister
	l.movhi	r3, hi(0)
	l.sfeq	r18, r11
	l.bf	.L8
	l.or	r16, r11, r11
	l.jal	readRtcRegister
	l.or	r3, r28, r28
	l.or	r3, r26, r26
	l.jal	readRtcRegister
	l.or	r18, r11, r11
	l.or	r3, r24, r24
	l.jal	readRtcRegister
	l.or	r30, r11, r11
	l.or	r3, r22, r22
	l.jal	readRtcRegister
	l.or	r14, r11, r11
	l.ori	r3, r0, 1
	l.jal	readRtcRegister
	l.or	r2, r11, r11
	l.sw	16(r1), r11
	l.sw	0(r1), r18
	l.sw	20(r1), r16
	l.sw	12(r1), r2
	l.sw	8(r1), r14
	l.sw	4(r1), r30
	l.jal	printf_
	l.or	r3, r20, r20
	l.j	.L8
	l.or	r18, r16, r16
	.size	printTimeComplete, .-printTimeComplete
	.ident	"GCC: (GNU) 13.2.0"
