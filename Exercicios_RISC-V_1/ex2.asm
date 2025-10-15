.text
	li	a7, 	5
	# chamada do sistema para ler do teclado
	ecall
	mv	s0,	a0
	# chamada do sistema para ler do teclado
	ecall
	mv	s1,	a0
	# multiplica e armazena em a0
	mul	a0, 	s0, 	s1
	# chamada do sistema para exibir no console
	li	a7,	1
	ecall
	