.data
vetor:	.space	40
espaco:	.asciz	" "

.text
	la	a1,	vetor
	addi	a2,	a1, 	40
	jal	ler_vetor
	la	a0,	vetor
	jal	bubble_sort
	la	a1,	vetor
	addi	a2,	a1, 	40
	jal	escrever_vetor
	
	li	a7,	10
	ecall
	
ler_vetor:
	bge	a1,	a2,	retornar
	li	a7, 	5
	ecall
	sw	a0, 	0(a1)
	addi	a1,	a1,	4
	j	ler_vetor
	
escrever_vetor:
	la	t0, 	espaco
	lbu	t1,	0(t0)
	
	lw	a0,	0(a1)
	li	a7,	1
	ecall
	
	addi	a1,	a1,	4
	bge	a1,	a2,	retornar
	mv	a0,	t1
	li	a7,	11
	ecall
	
	j	escrever_vetor
retornar:
	ret
	
bubble_sort:
	ble	a2,	a0,	fim
	addi	a1,	a0,	4
loop_interno:
	ble	a2,	a1, 	prox_it
	lw	t0, 	0(a0)
	lw	t1,	0(a1)
	ble	t0,	t1,	continue
	sw	t0,	0(a1)
	sw	t1,	0(a0)
continue:
	addi	a1, 	a1,	4
	j	loop_interno
prox_it:
	addi	a0,	a0,	4
	j	bubble_sort
fim:
	ret
	
	
	
	
