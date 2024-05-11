	.file	"assert.c"
	.section	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"dead!"
	.section	.text
	.align 4
	.global	assert_die
	.type	assert_die, @function
assert_die:
	l.movhi	r3, ha(.LC0)
	l.addi	r1, r1, -4
	l.sw	0(r1), r9
	l.jal	puts
	l.addi	r3, r3, lo(.LC0)
.L2:
	l.j	.L2
	 l.nop

	.size	assert_die, .-assert_die
	.global	assert_printf
	.section	.data
	.align 4
	.type	assert_printf, @object
	.size	assert_printf, 4
assert_printf:
	.long	printf_
	.ident	"GCC: (GNU) 13.2.0"
