.data
A:	.word	1, 5, 4, 3, 2, 8
msg:	.asciz	"soma="

.text
MAIN:
	li	a7,	4
	la	a0,	msg
	ecall
	la	a0, 	A
	li	a1, 	6
	jal	SOMAP
	li	a7, 	1
	ecall
	li	a7, 	10
	ecall
SOMAP:
	mv	t0, 	a0
	li	a0, 	0
laco:	bge	t1, 	a1,	fim
	lw	t2, 	0(t0)
	andi	t3, 	t2,	1
	bne	t3, 	zero,	impar
	add	a0,	a0,	t2
impar:	addi	t1, 	t1,	1
	addi	t0,	t0,	4
	j	laco
fim:
	ret