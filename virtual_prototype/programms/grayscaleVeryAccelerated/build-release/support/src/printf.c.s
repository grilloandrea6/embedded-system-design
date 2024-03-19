	.file	"printf.c"
	.section	.text
	.align 4
	.type	_out_buffer, @function
_out_buffer:
	l.ori	r17, r0, 24
	l.sll	r3, r3, r17
	l.sfgeu	r5, r6
	l.bf	.L1
	l.sra	r3, r3, r17
	l.add	r4, r4, r5
	l.sb	0(r4), r3
.L1:
	l.jr	r9
	 l.nop

	.size	_out_buffer, .-_out_buffer
	.align 4
	.type	_out_null, @function
_out_null:
	l.jr	r9
	 l.nop

	.size	_out_null, .-_out_null
	.align 4
	.type	_ntoa_format, @function
_ntoa_format:
	l.addi	r1, r1, -48
	l.sw	28(r1), r26
	l.movhi	r29, hi(0)
	l.lwz	r17, 64(r1)
	l.andi	r26, r17, 2
	l.sw	4(r1), r14
	l.sw	8(r1), r16
	l.sw	16(r1), r20
	l.sw	20(r1), r22
	l.sw	24(r1), r24
	l.sw	32(r1), r28
	l.sw	36(r1), r30
	l.sw	12(r1), r18
	l.sw	40(r1), r2
	l.sw	44(r1), r9
	l.sfne	r26, r29
	l.or	r20, r3, r3
	l.or	r22, r4, r4
	l.or	r14, r5, r5
	l.or	r24, r6, r6
	l.or	r28, r7, r7
	l.or	r16, r8, r8
	l.lbz	r23, 51(r1)
	l.lwz	r19, 52(r1)
	l.lwz	r21, 56(r1)
	l.bf	.L5
	l.lwz	r30, 60(r1)
	l.sfeq	r30, r29
	l.bf	.L6
	l.andi	r25, r17, 1
	l.sfeq	r25, r29
	l.bf	.L71
	l.ori	r27, r0, 32
	l.sfne	r23, r29
	l.bf	.L7
	 l.nop

	l.andi	r27, r17, 12
	l.sfeq	r27, r29
	l.bf	.L6
	 l.nop

.L7:
	l.addi	r30, r30, -1
.L6:
	l.ori	r27, r0, 32
.L71:
	l.j	.L8
	l.ori	r29, r0, 48
.L9:
	l.bnf	.L12
	l.add	r31, r28, r16
	l.sb	0(r31), r29
	l.addi	r16, r16, 1
.L8:
	l.sfgtu	r21, r16
	l.bf	.L9
	l.sfne	r16, r27
.L12:
	l.movhi	r27, hi(0)
	l.sfne	r25, r27
	l.bnf	.L5
	l.ori	r25, r0, 32
	l.ori	r27, r0, 48
.L10:
	l.sfgeu	r16, r30
	l.bf	.L5
	l.sfne	r16, r25
	l.bf	.L13
	 l.nop

.L5:
	l.andi	r25, r17, 16
	l.movhi	r27, hi(0)
	l.sfeq	r25, r27
	l.bf	.L14
	l.andi	r25, r17, 1024
	l.sfne	r25, r27
	l.bf	.L15
	l.sfeq	r16, r27
	l.bf	.L15
	l.sfeq	r16, r21
	l.bf	.L16
	l.sfne	r16, r30
	l.bf	.L72
	l.ori	r21, r0, 16
.L16:
	l.addi	r21, r16, -1
	l.movhi	r25, hi(0)
	l.sfeq	r21, r25
	l.bf	.L38
	l.ori	r25, r0, 16
	l.sfne	r19, r25
	l.bf	.L17
	l.ori	r25, r0, 2
	l.addi	r16, r16, -2
.L18:
	l.andi	r19, r17, 32
	l.movhi	r21, hi(0)
	l.sfne	r19, r21
	l.bf	.L20
	l.ori	r19, r0, 32
	l.sfeq	r16, r19
	l.bf	.L21
	l.add	r19, r28, r16
	l.ori	r21, r0, 120
.L66:
	l.sb	0(r19), r21
	l.addi	r16, r16, 1
	l.ori	r19, r0, 32
.L73:
	l.sfeq	r16, r19
	l.bf	.L21
	 l.nop

.L37:
	l.add	r19, r28, r16
	l.ori	r21, r0, 48
	l.sb	0(r19), r21
	l.addi	r16, r16, 1
.L14:
	l.ori	r19, r0, 32
	l.sfeq	r16, r19
	l.bf	.L21
	l.movhi	r21, hi(0)
	l.sfeq	r23, r21
	l.bf	.L25
	l.andi	r21, r17, 4
	l.add	r19, r28, r16
	l.ori	r21, r0, 45
.L68:
	l.sb	0(r19), r21
.L67:
	l.j	.L24
	l.addi	r16, r16, 1
.L13:
	l.add	r29, r28, r16
	l.sb	0(r29), r27
	l.j	.L10
	l.addi	r16, r16, 1
.L38:
	l.movhi	r16, hi(0)
.L15:
	l.ori	r21, r0, 16
.L72:
	l.sfne	r19, r21
	l.bnf	.L18
	l.ori	r21, r0, 2
	l.sfne	r19, r21
	l.bf	.L73
	l.ori	r19, r0, 32
	l.sfeq	r16, r19
	l.bf	.L21
	l.add	r19, r28, r16
.L70:
	l.j	.L66
	l.ori	r21, r0, 98
.L20:
	l.sfne	r16, r19
	l.bf	.L23
	l.add	r19, r28, r16
.L21:
	l.ori	r16, r0, 32
.L24:
	l.andi	r17, r17, 3
	l.movhi	r19, hi(0)
	l.sfeq	r17, r19
	l.bf	.L39
	l.or	r18, r16, r16
	l.or	r18, r14, r14
.L28:
	l.add	r18, r16, r18
	l.movhi	r17, hi(0)
.L69:
	l.sfne	r16, r17
	l.or	r11, r18, r18
	l.bf	.L32
	l.sub	r5, r18, r16
	l.sfeq	r26, r17
	l.bf	.L4
	l.sub	r16, r18, r14
	l.ori	r18, r0, 32
.L34:
	l.sfgtu	r30, r16
	l.bf	.L35
	l.add	r11, r14, r16
.L4:
	l.lwz	r14, 4(r1)
	l.lwz	r16, 8(r1)
	l.lwz	r18, 12(r1)
	l.lwz	r20, 16(r1)
	l.lwz	r22, 20(r1)
	l.lwz	r24, 24(r1)
	l.lwz	r26, 28(r1)
	l.lwz	r28, 32(r1)
	l.lwz	r30, 36(r1)
	l.lwz	r2, 40(r1)
	l.lwz	r9, 44(r1)
	l.jr	r9
	l.addi	r1, r1, 48
.L23:
	l.j	.L66
	l.ori	r21, r0, 88
.L25:
	l.movhi	r23, hi(0)
	l.sfeq	r21, r23
	l.bf	.L26
	l.ori	r21, r0, 43
	l.j	.L68
	l.add	r19, r28, r16
.L26:
	l.andi	r21, r17, 8
	l.sfeq	r21, r23
	l.bf	.L24
	l.add	r21, r28, r16
	l.j	.L67
	l.sb	0(r21), r19
.L30:
	l.sw	0(r1), r3
	l.or	r6, r24, r24
	l.jalr	r20
	l.or	r4, r22, r22
	l.addi	r18, r18, 1
	l.lwz	r3, 0(r1)
.L27:
	l.sfgtu	r30, r18
	l.bf	.L30
	l.add	r5, r2, r18
	l.sfleu	r16, r30
	l.bf	.L64
	l.sub	r18, r30, r16
	l.movhi	r18, hi(0)
.L64:
	l.j	.L28
	l.add	r18, r18, r14
.L39:
	l.sub	r2, r14, r16
	l.j	.L27
	l.ori	r3, r0, 32
.L32:
	l.addi	r16, r16, -1
	l.add	r17, r28, r16
	l.or	r6, r24, r24
	l.or	r4, r22, r22
	l.jalr	r20
	l.lbz	r3, 0(r17)
	l.j	.L69
	l.movhi	r17, hi(0)
.L35:
	l.or	r6, r24, r24
	l.or	r5, r11, r11
	l.or	r4, r22, r22
	l.jalr	r20
	l.or	r3, r18, r18
	l.j	.L34
	l.addi	r16, r16, 1
.L17:
	l.sfeq	r19, r25
	l.bnf	.L37
	l.or	r16, r21, r21
	l.j	.L70
	l.add	r19, r28, r16
	.size	_ntoa_format, .-_ntoa_format
	.global	__umodsi3
	.global	__udivsi3
	.align 4
	.type	_ntoa_long, @function
_ntoa_long:
	l.addi	r1, r1, -108
	l.movhi	r17, hi(0)
	l.sw	72(r1), r18
	l.sw	76(r1), r20
	l.sw	88(r1), r26
	l.sw	92(r1), r28
	l.sw	100(r1), r2
	l.sw	64(r1), r14
	l.sw	68(r1), r16
	l.sw	80(r1), r22
	l.sw	84(r1), r24
	l.sw	96(r1), r30
	l.sw	104(r1), r9
	l.sw	20(r1), r3
	l.sw	24(r1), r4
	l.sw	28(r1), r5
	l.sfne	r7, r17
	l.or	r26, r6, r6
	l.or	r2, r7, r7
	l.andi	r28, r8, 0xff
	l.lwz	r18, 108(r1)
	l.bf	.L75
	l.lwz	r20, 120(r1)
	l.xori	r17, r0, -17
	l.and	r20, r20, r17
.L75:
	l.andi	r17, r20, 1024
	l.movhi	r19, hi(0)
	l.sfeq	r17, r19
	l.bf	.L91
	l.andi	r17, r20, 32
	l.sfeq	r2, r19
	l.bf	.L92
	l.lwz	r17, 116(r1)
	l.andi	r17, r20, 32
	l.movhi	r19, hi(0)
.L91:
	l.sfne	r17, r19
	l.bf	.L88
	l.ori	r16, r0, 65
	l.ori	r16, r0, 97
.L88:
	l.andi	r16, r16, 0xff
	l.or	r24, r2, r2
	l.addi	r22, r1, 32
	l.movhi	r2, hi(0)
	l.ori	r14, r0, 9
	l.addi	r16, r16, -10
	l.ori	r30, r0, 32
.L80:
	l.or	r4, r18, r18
	l.jal	__umodsi3
	l.or	r3, r24, r24
	l.sfgtu	r11, r14
	l.bf	.L78
	l.andi	r17, r11, 0xff
	l.addi	r17, r17, 48
.L90:
	l.ori	r19, r0, 24
	l.sll	r17, r17, r19
	l.sra	r17, r17, r19
	l.sb	0(r22), r17
	l.or	r4, r18, r18
	l.jal	__udivsi3
	l.or	r3, r24, r24
	l.sfltu	r24, r18
	l.bf	.L77
	l.addi	r2, r2, 1
	l.sfne	r2, r30
	l.bf	.L81
	l.addi	r22, r22, 1
.L77:
	l.lwz	r17, 116(r1)
.L92:
	l.sw	16(r1), r20
	l.sw	12(r1), r17
	l.sw	4(r1), r18
	l.sb	3(r1), r28
	l.lwz	r17, 112(r1)
	l.or	r8, r2, r2
	l.sw	8(r1), r17
	l.addi	r7, r1, 32
	l.or	r6, r26, r26
	l.lwz	r5, 28(r1)
	l.lwz	r4, 24(r1)
	l.jal	_ntoa_format
	l.lwz	r3, 20(r1)
	l.lwz	r9, 104(r1)
	l.lwz	r14, 64(r1)
	l.lwz	r16, 68(r1)
	l.lwz	r18, 72(r1)
	l.lwz	r20, 76(r1)
	l.lwz	r22, 80(r1)
	l.lwz	r24, 84(r1)
	l.lwz	r26, 88(r1)
	l.lwz	r28, 92(r1)
	l.lwz	r30, 96(r1)
	l.lwz	r2, 100(r1)
	l.jr	r9
	l.addi	r1, r1, 108
.L81:
	l.j	.L80
	l.or	r24, r11, r11
.L78:
	l.j	.L90
	l.add	r17, r17, r16
	.size	_ntoa_long, .-_ntoa_long
	.global	__umoddi3
	.global	__udivdi3
	.align 4
	.type	_ntoa_long_long, @function
_ntoa_long_long:
	l.addi	r1, r1, -112
	l.or	r17, r7, r8
	l.movhi	r19, hi(0)
	l.sw	68(r1), r14
	l.sw	76(r1), r18
	l.sw	80(r1), r20
	l.sw	88(r1), r24
	l.sw	100(r1), r30
	l.sw	72(r1), r16
	l.sw	84(r1), r22
	l.sw	92(r1), r26
	l.sw	96(r1), r28
	l.sw	104(r1), r2
	l.sw	108(r1), r9
	l.sw	20(r1), r3
	l.sw	24(r1), r4
	l.sw	28(r1), r5
	l.sw	32(r1), r6
	l.sfne	r17, r19
	l.or	r30, r7, r7
	l.or	r14, r8, r8
	l.lwz	r24, 116(r1)
	l.lwz	r18, 120(r1)
	l.bf	.L94
	l.lwz	r20, 132(r1)
	l.xori	r21, r0, -17
	l.and	r20, r20, r21
.L94:
	l.andi	r21, r20, 1024
	l.movhi	r19, hi(0)
	l.sfeq	r21, r19
	l.bf	.L95
	l.sfeq	r17, r19
	l.bf	.L96
	l.movhi	r2, hi(0)
.L95:
	l.andi	r17, r20, 32
	l.movhi	r19, hi(0)
	l.sfne	r17, r19
	l.bf	.L108
	l.ori	r16, r0, 65
	l.ori	r16, r0, 97
.L108:
	l.andi	r16, r16, 0xff
	l.addi	r22, r1, 36
	l.movhi	r2, hi(0)
	l.ori	r28, r0, 9
	l.addi	r16, r16, -10
	l.ori	r26, r0, 32
.L101:
	l.or	r5, r24, r24
	l.or	r6, r18, r18
	l.or	r3, r30, r30
	l.jal	__umoddi3
	l.or	r4, r14, r14
	l.ori	r19, r0, 24
	l.andi	r17, r12, 0xff
	l.sll	r12, r12, r19
	l.sra	r12, r12, r19
	l.sfgts	r12, r28
	l.bf	.L98
	 l.nop

	l.addi	r17, r17, 48
.L110:
	l.sll	r17, r17, r19
	l.sra	r17, r17, r19
	l.sb	0(r22), r17
	l.or	r5, r24, r24
	l.or	r6, r18, r18
	l.or	r3, r30, r30
	l.jal	__udivdi3
	l.or	r4, r14, r14
	l.sfgtu	r24, r30
	l.bf	.L96
	l.addi	r2, r2, 1
	l.sfne	r24, r30
	l.bf	.L111
	l.sfne	r2, r26
	l.sfgtu	r18, r14
	l.bf	.L96
	l.sfne	r2, r26
.L111:
	l.bf	.L103
	l.addi	r22, r22, 1
.L96:
	l.lwz	r17, 128(r1)
	l.sw	12(r1), r17
	l.lwz	r17, 124(r1)
	l.sw	8(r1), r17
	l.lbz	r17, 115(r1)
	l.sw	16(r1), r20
	l.sw	4(r1), r18
	l.sb	3(r1), r17
	l.or	r8, r2, r2
	l.addi	r7, r1, 36
	l.lwz	r6, 32(r1)
	l.lwz	r5, 28(r1)
	l.lwz	r4, 24(r1)
	l.jal	_ntoa_format
	l.lwz	r3, 20(r1)
	l.lwz	r9, 108(r1)
	l.lwz	r14, 68(r1)
	l.lwz	r16, 72(r1)
	l.lwz	r18, 76(r1)
	l.lwz	r20, 80(r1)
	l.lwz	r22, 84(r1)
	l.lwz	r24, 88(r1)
	l.lwz	r26, 92(r1)
	l.lwz	r28, 96(r1)
	l.lwz	r30, 100(r1)
	l.lwz	r2, 104(r1)
	l.jr	r9
	l.addi	r1, r1, 112
.L103:
	l.or	r30, r11, r11
	l.j	.L101
	l.or	r14, r12, r12
.L98:
	l.add	r17, r17, r16
	l.j	.L110
	l.ori	r19, r0, 24
	.size	_ntoa_long_long, .-_ntoa_long_long
	.align 4
	.type	_out_char, @function
_out_char:
	l.ori	r17, r0, 24
	l.sll	r3, r3, r17
	l.sra	r3, r3, r17
	l.movhi	r17, hi(0)
	l.sfeq	r3, r17
	l.bf	.L112
	 l.nop

	l.j	_putchar
	 l.nop

.L112:
	l.jr	r9
	 l.nop

	.size	_out_char, .-_out_char
	.align 4
	.type	_out_fct, @function
_out_fct:
	l.ori	r17, r0, 24
	l.sll	r3, r3, r17
	l.sra	r3, r3, r17
	l.movhi	r17, hi(0)
	l.sfeq	r3, r17
	l.bf	.L114
	 l.nop

	l.lwz	r17, 0(r4)
	l.jr	r17
	l.lwz	r4, 4(r4)
.L114:
	l.jr	r9
	 l.nop

	.size	_out_fct, .-_out_fct
	.align 4
	.type	_vsnprintf, @function
_vsnprintf:
	l.addi	r1, r1, -92
	l.movhi	r17, hi(0)
	l.sw	52(r1), r16
	l.sw	60(r1), r20
	l.sw	64(r1), r22
	l.sw	84(r1), r2
	l.sw	48(r1), r14
	l.sw	56(r1), r18
	l.sw	68(r1), r24
	l.sw	72(r1), r26
	l.sw	76(r1), r28
	l.sw	80(r1), r30
	l.sw	88(r1), r9
	l.sfeq	r4, r17
	l.or	r22, r4, r4
	l.or	r20, r5, r5
	l.or	r16, r6, r6
	l.bnf	.L249
	l.or	r2, r7, r7
	l.movhi	r18, ha(_out_null)
	l.addi	r18, r18, lo(_out_null)
.L117:
	l.movhi	r24, hi(1179648)
	l.ori	r17, r24, 2081
	l.movhi	r28, hi(0)
	l.j	.L195
	l.sw	32(r1), r17
.L196:
	l.sfeq	r3, r17
	l.bf	.L203
	l.addi	r16, r16, 1
.L144:
	l.or	r5, r28, r28
.L263:
	l.addi	r26, r28, 1
	l.or	r6, r20, r20
	l.jalr	r18
	l.or	r4, r22, r22
	l.j	.L195
	l.or	r28, r26, r26
.L203:
	l.movhi	r17, hi(0)
	l.ori	r25, r0, 43
	l.ori	r27, r0, 48
	l.ori	r29, r0, 32
	l.ori	r31, r0, 35
.L119:
	l.lbs	r21, 0(r16)
	l.sfeq	r21, r25
	l.lbz	r19, 0(r16)
	l.bf	.L121
	l.addi	r23, r16, 1
	l.sfgts	r21, r25
	l.bf	.L122
	l.ori	r13, r0, 45
	l.sfeq	r21, r29
	l.bf	.L123
	l.sfeq	r21, r31
	l.bf	.L124
	l.ori	r21, r0, 24
.L262:
	l.sll	r19, r19, r21
	l.sra	r19, r19, r21
	l.addi	r21, r19, -48
	l.andi	r21, r21, 0xff
	l.ori	r25, r0, 9
	l.sfleu	r21, r25
	l.bnf	.L239
	l.ori	r21, r0, 42
	l.j	.L200
	l.movhi	r30, hi(0)
.L122:
	l.sfeq	r21, r13
	l.bf	.L126
	l.sfne	r21, r27
	l.bf	.L262
	l.ori	r21, r0, 24
	l.ori	r17, r17, 1
.L127:
	l.j	.L119
	l.or	r16, r23, r23
.L126:
	l.j	.L127
	l.ori	r17, r17, 2
.L121:
	l.j	.L127
	l.ori	r17, r17, 4
.L123:
	l.j	.L127
	l.ori	r17, r17, 8
.L124:
	l.j	.L127
	l.ori	r17, r17, 16
.L128:
	l.ori	r19, r0, 2
	l.sll	r21, r30, r19
	l.add	r19, r21, r30
	l.add	r19, r19, r19
	l.addi	r19, r19, -48
	l.add	r30, r23, r19
	l.or	r16, r27, r27
.L200:
	l.lbs	r23, 0(r16)
	l.addi	r21, r23, -48
	l.andi	r21, r21, 0xff
	l.sfleu	r21, r25
	l.bf	.L128
	l.addi	r27, r16, 1
.L129:
	l.lbs	r21, 0(r16)
	l.ori	r19, r0, 46
	l.sfne	r21, r19
	l.bf	.L132
	l.movhi	r14, hi(0)
	l.lbs	r25, 1(r16)
	l.addi	r21, r25, -48
	l.andi	r21, r21, 0xff
	l.ori	r27, r0, 9
	l.sfleu	r21, r27
	l.addi	r23, r16, 1
	l.bnf	.L235
	l.ori	r17, r17, 1024
	l.j	.L133
	l.or	r16, r23, r23
.L239:
	l.sfne	r19, r21
	l.bf	.L129
	l.movhi	r30, hi(0)
	l.movhi	r25, hi(0)
	l.lwz	r19, 0(r2)
	l.sfges	r19, r25
	l.bf	.L130
	l.addi	r21, r2, 4
	l.ori	r17, r17, 2
	l.sub	r30, r0, r19
.L131:
	l.or	r16, r23, r23
	l.j	.L129
	l.or	r2, r21, r21
.L130:
	l.j	.L131
	l.or	r30, r19, r19
.L135:
	l.ori	r19, r0, 2
	l.sll	r23, r14, r19
	l.add	r21, r23, r14
	l.add	r21, r21, r21
	l.addi	r21, r21, -48
	l.add	r14, r25, r21
	l.or	r16, r29, r29
.L133:
	l.lbs	r25, 0(r16)
	l.addi	r23, r25, -48
	l.andi	r23, r23, 0xff
	l.sfleu	r23, r27
	l.bf	.L135
	l.addi	r29, r16, 1
.L132:
	l.lbs	r23, 0(r16)
	l.ori	r27, r0, 108
	l.sfeq	r23, r27
	l.bf	.L136
	l.addi	r25, r16, 1
	l.sfgts	r23, r27
	l.bf	.L137
	l.ori	r19, r0, 104
	l.sfeq	r23, r19
	l.bf	.L138
	l.ori	r19, r0, 106
	l.sfeq	r23, r19
	l.bf	.L139
	 l.nop

.L252:
	l.or	r25, r16, r16
.L140:
	l.lbs	r3, 0(r25)
	l.ori	r27, r0, 120
	l.sfgts	r3, r27
	l.bf	.L144
	l.addi	r16, r25, 1
	l.ori	r23, r0, 99
	l.sfgts	r3, r23
	l.bf	.L145
	l.lwz	r19, 32(r1)
	l.ori	r19, r0, 98
	l.sfeq	r3, r19
	l.bf	.L208
	l.sfeq	r3, r23
	l.bf	.L147
	l.ori	r19, r0, 37
	l.sfeq	r3, r19
	l.bf	.L144
	l.ori	r19, r0, 88
	l.sfeq	r3, r19
	l.bnf	.L144
	l.ori	r17, r17, 32
	l.ori	r23, r0, 16
.L156:
	l.xori	r25, r0, -13
	l.j	.L155
	l.and	r17, r17, r25
.L235:
	l.ori	r19, r0, 42
	l.sfne	r25, r19
	l.bf	.L207
	 l.nop

	l.movhi	r19, hi(0)
	l.lwz	r21, 0(r2)
	l.sfges	r21, r19
	l.bf	.L247
	l.or	r14, r21, r21
	l.movhi	r14, hi(0)
.L247:
	l.addi	r16, r16, 2
	l.j	.L132
	l.addi	r2, r2, 4
.L207:
	l.or	r16, r23, r23
	l.j	.L132
	l.movhi	r14, hi(0)
.L137:
	l.ori	r19, r0, 122
	l.sfeq	r23, r19
	l.bnf	.L252
	 l.nop

.L141:
	l.j	.L140
	l.ori	r17, r17, 256
.L136:
	l.lbs	r27, 1(r16)
	l.sfeq	r27, r23
	l.bnf	.L141
	 l.nop

	l.ori	r17, r17, 768
.L253:
	l.j	.L140
	l.addi	r25, r16, 2
.L138:
	l.lbs	r27, 1(r16)
	l.sfeq	r27, r23
	l.bf	.L143
	 l.nop

	l.j	.L140
	l.ori	r17, r17, 128
.L143:
	l.j	.L253
	l.ori	r17, r17, 192
.L139:
	l.j	.L140
	l.ori	r17, r17, 512
.L145:
	l.addi	r25, r3, -100
	l.andi	r25, r25, 0xff
	l.ori	r23, r0, 1
	l.sll	r23, r23, r25
	l.and	r23, r23, r19
	l.movhi	r19, hi(0)
	l.sfne	r23, r19
	l.bf	.L150
	l.ori	r19, r0, 115
	l.sfeq	r3, r19
	l.bf	.L151
	l.ori	r19, r0, 112
	l.sfeq	r3, r19
	l.bnf	.L263
	l.or	r5, r28, r28
	l.ori	r17, r17, 33
	l.sw	12(r1), r17
	l.ori	r17, r0, 8
	l.sw	8(r1), r17
	l.ori	r17, r0, 16
	l.addi	r26, r2, 4
	l.sw	4(r1), r14
	l.j	.L257
	l.sw	0(r1), r17
.L150:
	l.ori	r23, r0, 111
	l.sfeq	r3, r23
	l.bnf	.L236
	l.sfgts	r3, r23
	l.j	.L156
	l.ori	r23, r0, 8
.L198:
	l.bf	.L154
	l.ori	r23, r0, 16
	l.xori	r23, r0, -17
	l.and	r17, r17, r23
	l.ori	r23, r0, 10
.L154:
	l.ori	r19, r0, 100
	l.sfeq	r3, r19
	l.bf	.L155
	l.xori	r25, r0, -13
	l.j	.L155
	l.and	r17, r17, r25
.L160:
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L267
	l.addi	r26, r2, 4
	l.lwz	r7, 0(r2)
.L167:
	l.ori	r19, r0, 31
.L264:
	l.srl	r8, r7, r19
	l.movhi	r19, hi(0)
	l.sfges	r7, r19
	l.bf	.L169
	 l.nop

	l.sub	r7, r0, r7
.L169:
	l.sw	12(r1), r17
	l.sw	8(r1), r30
	l.sw	4(r1), r14
	l.sw	0(r1), r23
.L256:
	l.or	r6, r20, r20
	l.or	r5, r28, r28
	l.or	r4, r22, r22
	l.jal	_ntoa_long
	l.or	r3, r18, r18
	l.j	.L261
	l.or	r28, r11, r11
.L267:
	l.andi	r25, r17, 64
	l.sfeq	r25, r19
	l.lwz	r7, 0(r2)
	l.bnf	.L254
	l.ori	r19, r0, 24
	l.andi	r25, r17, 128
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L264
	l.ori	r19, r0, 31
	l.ori	r19, r0, 16
.L254:
	l.sll	r7, r7, r19
	l.j	.L167
	l.sra	r7, r7, r19
.L159:
	l.sfeq	r25, r19
	l.bf	.L170
	l.andi	r25, r17, 256
	l.lwz	r7, 0(r2)
	l.lwz	r8, 4(r2)
	l.addi	r26, r2, 8
	l.sw	20(r1), r17
	l.sw	16(r1), r30
	l.sw	12(r1), r14
	l.sw	8(r1), r23
	l.sw	4(r1), r0
	l.j	.L258
	l.sb	3(r1), r0
.L170:
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L171
	l.addi	r26, r2, 4
	l.sw	12(r1), r17
	l.sw	8(r1), r30
	l.sw	4(r1), r14
	l.sw	0(r1), r23
.L257:
	l.movhi	r8, hi(0)
	l.j	.L256
	l.lwz	r7, 0(r2)
.L171:
	l.andi	r25, r17, 64
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L172
	l.lwz	r7, 0(r2)
	l.andi	r7, r7, 255
.L173:
	l.sw	12(r1), r17
	l.sw	8(r1), r30
	l.sw	4(r1), r14
	l.sw	0(r1), r23
	l.j	.L256
	l.movhi	r8, hi(0)
.L172:
	l.andi	r25, r17, 128
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L173
	 l.nop

	l.j	.L173
	l.andi	r7, r7, 65535
.L147:
	l.andi	r26, r17, 2
	l.movhi	r17, hi(0)
	l.sfeq	r26, r17
	l.bnf	.L176
	l.ori	r14, r0, 1
	l.movhi	r14, hi(0)
	l.j	.L175
	l.ori	r24, r0, 32
.L177:
	l.or	r4, r22, r22
	l.jalr	r18
	l.or	r3, r24, r24
.L175:
	l.add	r5, r28, r14
	l.addi	r14, r14, 1
	l.sfgtu	r30, r14
	l.bf	.L177
	l.or	r6, r20, r20
	l.movhi	r19, hi(0)
	l.sfne	r30, r19
	l.bf	.L245
	l.addi	r17, r30, -1
	l.movhi	r17, hi(0)
.L245:
	l.add	r28, r28, r17
	l.addi	r17, r30, 1
	l.bf	.L176
	l.or	r14, r17, r17
	l.ori	r14, r0, 2
.L176:
	l.addi	r17, r2, 4
	l.sw	24(r1), r17
	l.or	r6, r20, r20
	l.or	r5, r28, r28
	l.or	r4, r22, r22
	l.jalr	r18
	l.lbz	r3, 3(r2)
	l.movhi	r17, hi(0)
	l.sfne	r26, r17
	l.bnf	.L179
	l.addi	r24, r28, 1
	l.or	r26, r14, r14
	l.or	r5, r24, r24
	l.j	.L178
	l.ori	r2, r0, 32
.L180:
	l.or	r4, r22, r22
	l.or	r3, r2, r2
	l.jalr	r18
	l.addi	r28, r5, 1
	l.addi	r26, r26, 1
	l.or	r5, r28, r28
.L178:
	l.sfltu	r26, r30
	l.bf	.L180
	l.or	r6, r20, r20
	l.sfgeu	r30, r14
	l.bf	.L244
	l.sub	r23, r30, r14
	l.movhi	r23, hi(0)
.L244:
	l.add	r24, r24, r23
.L179:
	l.or	r28, r24, r24
	l.j	.L195
	l.lwz	r2, 24(r1)
.L151:
	l.addi	r19, r2, 4
	l.sw	28(r1), r19
	l.movhi	r19, hi(0)
	l.sfeq	r14, r19
	l.xori	r23, r0, -1
	l.bf	.L243
	l.lwz	r26, 0(r2)
	l.or	r23, r14, r14
.L243:
	l.add	r27, r26, r23
	l.or	r23, r26, r26
.L182:
	l.lbs	r29, 0(r23)
	l.movhi	r19, hi(0)
	l.sfeq	r29, r19
	l.bf	.L183
	l.sfne	r27, r23
	l.bf	.L184
	 l.nop

.L183:
	l.andi	r19, r17, 1024
	l.movhi	r21, hi(0)
	l.sw	24(r1), r19
	l.sfeq	r19, r21
	l.bf	.L185
	l.sub	r24, r23, r26
	l.sfleu	r24, r14
	l.bf	.L265
	l.andi	r2, r17, 2
	l.or	r24, r14, r14
.L185:
	l.andi	r2, r17, 2
.L265:
	l.movhi	r17, hi(0)
	l.sfeq	r2, r17
	l.bnf	.L189
	l.or	r17, r28, r28
	l.or	r5, r28, r28
	l.sub	r27, r24, r28
	l.j	.L186
	l.ori	r3, r0, 32
.L184:
	l.j	.L182
	l.addi	r23, r23, 1
.L188:
	l.addi	r17, r5, 1
	l.sw	44(r1), r27
	l.sw	40(r1), r17
	l.sw	36(r1), r3
	l.jalr	r18
	l.or	r4, r22, r22
	l.lwz	r17, 40(r1)
	l.or	r5, r17, r17
	l.lwz	r3, 36(r1)
	l.lwz	r27, 44(r1)
.L186:
	l.add	r17, r27, r5
	l.sfltu	r17, r30
	l.bf	.L188
	l.or	r6, r20, r20
	l.sfgeu	r30, r24
	l.bf	.L241
	l.sub	r17, r30, r24
	l.movhi	r17, hi(0)
.L241:
	l.addi	r23, r24, 1
	l.add	r28, r28, r17
	l.add	r24, r17, r23
	l.j	.L189
	l.or	r17, r28, r28
.L216:
	l.or	r14, r27, r27
.L191:
	l.addi	r27, r17, 1
	l.sw	36(r1), r27
	l.or	r5, r17, r17
	l.or	r6, r20, r20
	l.jalr	r18
	l.or	r4, r22, r22
	l.lwz	r27, 36(r1)
	l.or	r17, r27, r27
.L189:
	l.sub	r27, r17, r28
	l.add	r27, r26, r27
	l.lbs	r3, 0(r27)
	l.movhi	r19, hi(0)
	l.sfeq	r3, r19
	l.bf	.L268
	l.lwz	r21, 24(r1)
	l.sfeq	r21, r19
	l.bf	.L191
	l.sfne	r14, r19
	l.bf	.L216
	l.addi	r27, r14, -1
	l.movhi	r19, hi(0)
.L268:
	l.sfne	r2, r19
	l.bnf	.L193
	 l.nop

	l.or	r5, r17, r17
	l.sub	r2, r24, r17
	l.j	.L192
	l.ori	r26, r0, 32
.L194:
	l.sw	24(r1), r17
	l.or	r4, r22, r22
	l.or	r3, r26, r26
	l.jalr	r18
	l.addi	r28, r5, 1
	l.or	r5, r28, r28
	l.lwz	r17, 24(r1)
.L192:
	l.add	r21, r5, r2
	l.sfgtu	r30, r21
	l.bf	.L194
	l.or	r6, r20, r20
	l.sfgeu	r30, r24
	l.bf	.L240
	l.sub	r21, r30, r24
	l.movhi	r21, hi(0)
.L240:
	l.add	r17, r17, r21
.L193:
	l.or	r28, r17, r17
	l.j	.L195
	l.lwz	r2, 28(r1)
.L249:
	l.j	.L117
	l.or	r18, r3, r3
.L208:
	l.j	.L156
	l.ori	r23, r0, 2
.L236:
	l.bf	.L198
	l.sfeq	r3, r27
	l.ori	r19, r0, 105
	l.xori	r23, r0, -17
	l.sfne	r3, r19
	l.and	r17, r17, r23
	l.bf	.L154
	l.ori	r23, r0, 10
.L155:
	l.andi	r25, r17, 1024
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L266
	l.ori	r19, r0, 105
	l.xori	r25, r0, -2
	l.and	r17, r17, r25
.L266:
	l.sfeq	r3, r19
	l.bf	.L158
	l.andi	r25, r17, 512
	l.ori	r19, r0, 100
	l.sfne	r3, r19
	l.bf	.L159
	l.movhi	r19, hi(0)
.L158:
	l.movhi	r19, hi(0)
	l.sfeq	r25, r19
	l.bf	.L160
	l.andi	r25, r17, 256
	l.lwz	r25, 0(r2)
	l.sfges	r25, r19
	l.addi	r26, r2, 8
	l.or	r7, r25, r25
	l.bf	.L161
	l.lwz	r8, 4(r2)
	l.sfne	r8, r19
	l.sub	r27, r0, r8
	l.bf	.L248
	l.ori	r29, r0, 1
	l.movhi	r29, hi(0)
.L248:
	l.sub	r7, r0, r25
	l.sub	r7, r7, r29
	l.or	r8, r27, r27
.L161:
	l.sw	20(r1), r17
	l.ori	r17, r0, 31
	l.srl	r25, r25, r17
	l.sw	16(r1), r30
	l.sw	12(r1), r14
	l.sw	8(r1), r23
	l.sw	4(r1), r0
	l.sb	3(r1), r25
.L258:
	l.or	r6, r20, r20
	l.or	r5, r28, r28
	l.or	r4, r22, r22
	l.jal	_ntoa_long_long
	l.or	r3, r18, r18
	l.or	r28, r11, r11
.L261:
	l.or	r2, r26, r26
.L195:
	l.lbs	r3, 0(r16)
	l.movhi	r17, hi(0)
	l.sfne	r3, r17
	l.bf	.L196
	l.ori	r17, r0, 37
	l.sfltu	r28, r20
	l.bf	.L197
	l.or	r5, r28, r28
	l.addi	r5, r20, -1
.L197:
	l.or	r6, r20, r20
	l.or	r4, r22, r22
	l.jalr	r18
	l.movhi	r3, hi(0)
	l.or	r11, r28, r28
	l.lwz	r14, 48(r1)
	l.lwz	r16, 52(r1)
	l.lwz	r18, 56(r1)
	l.lwz	r20, 60(r1)
	l.lwz	r22, 64(r1)
	l.lwz	r24, 68(r1)
	l.lwz	r26, 72(r1)
	l.lwz	r28, 76(r1)
	l.lwz	r30, 80(r1)
	l.lwz	r2, 84(r1)
	l.lwz	r9, 88(r1)
	l.jr	r9
	l.addi	r1, r1, 92
	.size	_vsnprintf, .-_vsnprintf
	.align 4
	.global	printf_
	.type	printf_, @function
printf_:
	l.addi	r1, r1, -8
	l.or	r6, r3, r3
	l.movhi	r3, ha(_out_char)
	l.addi	r7, r1, 8
	l.addi	r4, r1, 3
	l.xori	r5, r0, -1
	l.sw	4(r1), r9
	l.jal	_vsnprintf
	l.addi	r3, r3, lo(_out_char)
	l.lwz	r9, 4(r1)
	l.jr	r9
	l.addi	r1, r1, 8
	.size	printf_, .-printf_
	.align 4
	.global	sprintf_
	.type	sprintf_, @function
sprintf_:
	l.addi	r1, r1, -4
	l.or	r6, r4, r4
	l.or	r4, r3, r3
	l.movhi	r3, ha(_out_buffer)
	l.addi	r7, r1, 4
	l.xori	r5, r0, -1
	l.sw	0(r1), r9
	l.jal	_vsnprintf
	l.addi	r3, r3, lo(_out_buffer)
	l.lwz	r9, 0(r1)
	l.jr	r9
	l.addi	r1, r1, 4
	.size	sprintf_, .-sprintf_
	.align 4
	.global	snprintf_
	.type	snprintf_, @function
snprintf_:
	l.addi	r1, r1, -4
	l.or	r6, r5, r5
	l.or	r5, r4, r4
	l.or	r4, r3, r3
	l.movhi	r3, ha(_out_buffer)
	l.addi	r7, r1, 4
	l.sw	0(r1), r9
	l.jal	_vsnprintf
	l.addi	r3, r3, lo(_out_buffer)
	l.lwz	r9, 0(r1)
	l.jr	r9
	l.addi	r1, r1, 4
	.size	snprintf_, .-snprintf_
	.align 4
	.global	vprintf_
	.type	vprintf_, @function
vprintf_:
	l.addi	r1, r1, -8
	l.or	r6, r3, r3
	l.movhi	r3, ha(_out_char)
	l.or	r7, r4, r4
	l.xori	r5, r0, -1
	l.addi	r4, r1, 3
	l.sw	4(r1), r9
	l.jal	_vsnprintf
	l.addi	r3, r3, lo(_out_char)
	l.lwz	r9, 4(r1)
	l.jr	r9
	l.addi	r1, r1, 8
	.size	vprintf_, .-vprintf_
	.align 4
	.global	vsnprintf_
	.type	vsnprintf_, @function
vsnprintf_:
	l.or	r7, r6, r6
	l.or	r6, r5, r5
	l.or	r5, r4, r4
	l.or	r4, r3, r3
	l.movhi	r3, ha(_out_buffer)
	l.j	_vsnprintf
	l.addi	r3, r3, lo(_out_buffer)
	.size	vsnprintf_, .-vsnprintf_
	.align 4
	.global	fctprintf
	.type	fctprintf, @function
fctprintf:
	l.addi	r1, r1, -12
	l.sw	0(r1), r3
	l.movhi	r3, ha(_out_fct)
	l.sw	4(r1), r4
	l.or	r6, r5, r5
	l.addi	r7, r1, 12
	l.or	r4, r1, r1
	l.xori	r5, r0, -1
	l.sw	8(r1), r9
	l.jal	_vsnprintf
	l.addi	r3, r3, lo(_out_fct)
	l.lwz	r9, 8(r1)
	l.jr	r9
	l.addi	r1, r1, 12
	.size	fctprintf, .-fctprintf
	.ident	"GCC: (GNU) 13.2.0"
