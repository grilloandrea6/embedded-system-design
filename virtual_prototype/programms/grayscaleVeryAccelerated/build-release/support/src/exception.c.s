	.file	"exception.c"
	.section	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"I$ error!"
	.section	.text
	.align 4
	.weak	i_cache_error_handler
	.type	i_cache_error_handler, @function
i_cache_error_handler:
	l.movhi	r3, ha(.LC0)
	l.j	puts
	l.addi	r3, r3, lo(.LC0)
	.size	i_cache_error_handler, .-i_cache_error_handler
	.section	.rodata.str1.1
.LC1:
	.string	"D$ error!"
	.section	.text
	.align 4
	.weak	d_cache_error_handler
	.type	d_cache_error_handler, @function
d_cache_error_handler:
	l.movhi	r3, ha(.LC1)
	l.j	puts
	l.addi	r3, r3, lo(.LC1)
	.size	d_cache_error_handler, .-d_cache_error_handler
	.section	.rodata.str1.1
.LC2:
	.string	"????"
	.section	.text
	.align 4
	.weak	illegal_instruction_handler
	.type	illegal_instruction_handler, @function
illegal_instruction_handler:
	l.movhi	r3, ha(.LC2)
	l.j	puts
	l.addi	r3, r3, lo(.LC2)
	.size	illegal_instruction_handler, .-illegal_instruction_handler
	.section	.rodata.str1.1
.LC3:
	.string	"ping"
	.section	.text
	.align 4
	.weak	external_interrupt_handler
	.type	external_interrupt_handler, @function
external_interrupt_handler:
	l.movhi	r3, ha(.LC3)
	l.j	puts
	l.addi	r3, r3, lo(.LC3)
	.size	external_interrupt_handler, .-external_interrupt_handler
	.section	.rodata.str1.1
.LC4:
	.string	"Syscall"
	.section	.text
	.align 4
	.weak	system_call_handler
	.type	system_call_handler, @function
system_call_handler:
	l.movhi	r3, ha(.LC4)
	l.j	puts
	l.addi	r3, r3, lo(.LC4)
	.size	system_call_handler, .-system_call_handler
	.ident	"GCC: (GNU) 13.2.0"
