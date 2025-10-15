.data
msg:	.asciz "Primo(", ")="

.text
	li	a7, 5
	ecall
	blez	a0, error
	mv	s0, a0	#s0 = o índice 
	li	a1, 1
	jal	prime_up_to
	mv	s1, a0 	#s1 = o primo
	li	a7, 4
	la	a0, msg
	ecall
	li	a7, 1
	mv	a0, s0
	ecall
	li	a7, 4
	la	a0, msg
	addi	a0, a0, 7
	ecall
	li	a7, 1
	mv	a0, s1
	ecall
	li 	a7, 10
	ecall
error:
	li 	a7, 10
	ecall
prime_up_to: # a0: índice do primo que queremos, a1: contador, a2: contador de primos
	beq	a0, a2, fim
	addi	a1, a1, 1
	addi	sp, sp, -12
	sw	a0, 8(sp)
	sw	a1, 4(sp)
	sw	ra, 0(sp)
	mv	a0, a1
	li	a1, 2
	jal	is_prime
	beqz	a0, link
	addi	a2, a2, 1
link:
	lw	a0, 8(sp)
	lw	a1, 4(sp)
	lw	ra, 0(sp)
	addi	sp, sp, 12
	j	prime_up_to
fim:	
	mv	a0, a1
	ret
is_prime: # a0: numero testado, a1: indice
	mul	t1, a1, a1 	# a = i^2
	blt	a0, t1, prime	# while (n <= i^2)
	rem	t1, a0, a1
	beqz	t1, return	# if (n % i == 0) then false
	addi	a1, a1, 1	# i++
	j	is_prime
prime:
	li	t1, 1
return:
	mv	a0, t1
	ret