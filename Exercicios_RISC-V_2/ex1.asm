.data
msg:	.asciz	"Modulo="

.text
	li	a7, 6
	ecall
	fmv.s	f0, fa0
	ecall
	fmv.s	f1, fa0
	fmul.s	f0, f0, f0
	fmul.s	f1, f1, f1
	fadd.s	f0, f1, f0
	fsqrt.s	f0, f0
	la	a0, msg
	li	a7, 4
	ecall
	li	a7, 2
	fmv.s	fa0, f0
	ecall
	li	a7, 10
	ecall