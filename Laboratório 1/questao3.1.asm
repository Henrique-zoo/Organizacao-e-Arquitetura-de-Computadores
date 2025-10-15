.data
PI_2:	.float	1.5707963
PI:	.float	3.1415926
DOIS_PI:	.float	6.2831853

.text	# Testando para x = 2pi
	la	t0, PI
    	flw	fa0, 0(t0)
    	li	t2, 0
    	fcvt.s.w	ft0, t2
    	fmul.s	fa0, fa0, ft0
    	
	jal	SINCOS
	
	li	a7, 2
	ecall
	
	li	a7, 11
	li	a0, 10
	ecall
	
	fmv.s	fa0, fa1
	li	a7, 2
	ecall
	
	li	a7, 10
	ecall

SINCOS:	addi	sp, sp, -4
	sw	ra, 0(sp)
	jal	norm
	li	t1, -1
	fmv.s	ft0, fa0
       	fmv.s   	ft3, fa0		# Constante = angulo de argumento para multiplicar por ft0 a cada iteração (x)^(2n)
        	li      	t0, 1		# Índice da iteração
        	li      	t1, 17		# Total de iterações
        	li      	t2, 1		# (-1)^n (começa com -1^0 = 1)
        	li      	t3, 1		# Fatorial (começa com 0! = 1)
        	li      	t4, -1		# Constante -1 para multiplicar por t2 a cada iteração
        	fcvt.s.w 	fa0, t0		# O primeiro termo da série de cosseno é 1
        	fcvt.s.w 	fa1, zero		# A série de seno é inicializada em 0 (seu primeiro termo será calculado no loop)
loop:   	fcvt.s.w 	ft1, t2
        	fcvt.s.w 	ft2, t3
        	fdiv.s  	ft1, ft1, ft2
        	fmul.s  	ft1, ft0, ft1
	andi    	t5, t0, 1
	bnez    	t5, sen		# Se t4 for impar, é um termo do seno
cos:	fadd.s  	fa0, fa0, ft1
	j       	comum
sen:    	fadd.s	fa1, fa1, ft1
        	mul	t2, t2, t4	# O sinal só muda a cada duas iterações
comum:  	addi	t0, t0, 1		# Incrementa o índice
	mul	t3, t3, t0	# É o fatorial para a próxima iteração
        	fmul.s	ft0, ft0, ft3	# É o x^n
	bne	t1, t0, loop
fim:    	beqz	a0, ninv
	fneg.s	fa0, fa0
ninv:	lw	ra, 0(sp)
	addi	sp, sp, 4
	ret

norm:	flw	ft0, PI_2, t0
	flw	ft1, PI, t0
	fgt.s	t0, fa0, ft0	# if fa0 > π/2: t0 = 1
	beqz	t0, elif
	j	subt
elif:	fneg.s	ft0, ft0		# ft0 = -π/2
	fneg.s	ft1, ft1		# ft1 = -π
	flt.s	t0, fa0, ft0	# if fa0 < -π/2: t0 = 1
	beqz	t0, else
subt:	fsub.s	fa0, ft1, fa0	# fa0 = π - fa0 ou fa0 = -π - fa0
	li	a0, 1		# flag para inverter o cosseno
	j	return
else:	li	a0, 0
return:	ret
