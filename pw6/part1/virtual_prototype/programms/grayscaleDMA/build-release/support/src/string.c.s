	.file	"string.c"
	.section	.text
	.align 4
	.global	memcpy
	.type	memcpy, @function
memcpy:
	l.movhi	r19, hi(0)
	l.sfeq	r5, r19
	l.bf	.L2
	l.or	r11, r3, r3
	l.sfeq	r3, r4
	l.bf	.L2
	l.sfgeu	r3, r4
	l.bf	.L3
	l.add	r17, r3, r5
	l.or	r17, r3, r4
	l.andi	r17, r17, 3
	l.sfeq	r17, r19
	l.bf	.L16
	l.xor	r17, r3, r4
	l.andi	r17, r17, 3
	l.sfne	r17, r19
	l.bf	.L5
	l.or	r17, r5, r5
	l.ori	r17, r0, 3
	l.sfleu	r5, r17
	l.bf	.L18
	l.and	r19, r4, r17
	l.ori	r17, r0, 4
	l.sub	r17, r17, r19
.L5:
	l.sub	r5, r5, r17
	l.movhi	r19, hi(0)
	l.add	r23, r4, r19
.L39:
	l.add	r21, r11, r19
	l.lbs	r23, 0(r23)
	l.addi	r19, r19, 1
	l.sb	0(r21), r23
	l.sfne	r17, r19
	l.bf	.L39
	l.add	r23, r4, r19
	l.add	r19, r11, r17
	l.add	r4, r4, r17
.L4:
	l.ori	r17, r0, 3
	l.sfleu	r5, r17
	l.bf	.L7
	l.ori	r17, r0, 2
	l.srl	r21, r5, r17
	l.sll	r21, r21, r17
	l.movhi	r17, hi(0)
.L8:
	l.add	r23, r4, r17
	l.lwz	r25, 0(r23)
	l.add	r23, r19, r17
	l.addi	r17, r17, 4
	l.sfne	r17, r21
	l.bf	.L8
	l.sw	0(r23), r25
	l.add	r19, r19, r17
	l.add	r4, r4, r17
.L7:
	l.andi	r5, r5, 3
	l.movhi	r17, hi(0)
	l.sfeq	r5, r17
	l.bf	.L2
	l.add	r23, r4, r17
.L40:
	l.add	r21, r19, r17
	l.lbs	r23, 0(r23)
	l.addi	r17, r17, 1
	l.sb	0(r21), r23
	l.sfne	r5, r17
	l.bf	.L40
	l.add	r23, r4, r17
.L2:
	l.jr	r9
	 l.nop

.L18:
	l.j	.L5
	l.or	r17, r5, r5
.L16:
	l.j	.L4
	l.or	r19, r3, r3
.L3:
	l.add	r4, r4, r5
	l.or	r19, r4, r17
	l.andi	r19, r19, 3
	l.movhi	r21, hi(0)
	l.sfeq	r19, r21
	l.bf	.L41
	l.ori	r19, r0, 3
	l.xor	r19, r4, r17
	l.andi	r19, r19, 3
	l.sfne	r19, r21
	l.bf	.L11
	l.or	r19, r5, r5
	l.ori	r19, r0, 4
	l.sfleu	r5, r19
	l.bf	.L11
	l.or	r19, r5, r5
	l.andi	r19, r4, 3
.L11:
	l.sub	r5, r5, r19
	l.xori	r23, r19, -1
	l.xori	r21, r0, -1
	l.add	r27, r4, r21
.L42:
	l.add	r25, r17, r21
	l.lbs	r27, 0(r27)
	l.addi	r21, r21, -1
	l.sb	0(r25), r27
	l.sfne	r21, r23
	l.bf	.L42
	l.add	r27, r4, r21
	l.sub	r17, r17, r19
	l.sub	r4, r4, r19
	l.ori	r19, r0, 3
.L41:
	l.sfleu	r5, r19
	l.bf	.L13
	l.ori	r19, r0, 2
	l.srl	r19, r5, r19
	l.or	r23, r19, r19
	l.xori	r21, r0, -4
.L14:
	l.add	r25, r4, r21
	l.lwz	r27, 0(r25)
	l.add	r25, r17, r21
	l.sw	0(r25), r27
	l.addi	r23, r23, -1
	l.movhi	r25, hi(0)
	l.sfne	r23, r25
	l.bf	.L14
	l.addi	r21, r21, -4
	l.sub	r19, r0, r19
	l.ori	r21, r0, 2
	l.sll	r19, r19, r21
	l.add	r17, r17, r19
	l.add	r4, r4, r19
.L13:
	l.andi	r5, r5, 3
	l.movhi	r19, hi(0)
	l.sfeq	r5, r19
	l.bf	.L2
	 l.nop

	l.xori	r5, r5, -1
	l.xori	r19, r0, -1
	l.add	r23, r4, r19
.L43:
	l.add	r21, r17, r19
	l.lbs	r23, 0(r23)
	l.addi	r19, r19, -1
	l.sb	0(r21), r23
	l.sfne	r19, r5
	l.bf	.L43
	l.add	r23, r4, r19
	l.j	.L2
	 l.nop

	.size	memcpy, .-memcpy
	.align 4
	.global	memmove
	.type	memmove, @function
memmove:
	l.j	memcpy
	 l.nop

	.size	memmove, .-memmove
	.align 4
	.global	bcopy
	.type	bcopy, @function
bcopy:
	l.or	r17, r4, r4
	l.or	r4, r3, r3
	l.j	memcpy
	l.or	r3, r17, r17
	.size	bcopy, .-bcopy
	.align 4
	.global	memset
	.type	memset, @function
memset:
	l.or	r11, r3, r3
	l.add	r5, r3, r5
	l.or	r17, r3, r3
	l.andi	r4, r4, 0xff
.L47:
	l.sfne	r17, r5
	l.bf	.L48
	 l.nop

	l.jr	r9
	 l.nop

.L48:
	l.sb	0(r17), r4
	l.j	.L47
	l.addi	r17, r17, 1
	.size	memset, .-memset
	.ident	"GCC: (GNU) 13.2.0"
