SINCOS: addi	sp, sp, -4
        sw	ra, 0(sp)
        jal	norm
        li	t1, -1
        fmv.s	ft0, fa0
        fmv.s   	ft3, fa0		# Constante = angulo de argumento para multiplicar por ft0 a cada iteração (x)^(2n)
        li      	t0, 1		# Índice da iteração
        li      	t1, 21		# Total de iterações
        li      	t2, 1		# (-1)^n (começa com -1^0 = 1)
        li      	t3, 1		# Fatorial (começa com 0! = 1)
        li      	t4, -1		# Constante -1 para multiplicar por t2 a cada iteração
        fcvt.s.w	fa0, t0		# O primeiro termo da série de cosseno é 1
        fcvt.s.w	fa1, zero		# A série de seno é inicializada em 0 (seu primeiro termo será calculado no loop)
rep:    fcvt.s.w	ft1, t2
        fcvt.s.w	ft2, t3
        fdiv.s	ft1, ft1, ft2
        fmul.s	ft1, ft0, ft1
        andi	t5, t0, 1
        bnez	t5, sen		# Se t4 for impar, é um termo do seno
cos:    fadd.s	fa0, fa0, ft1
        j		comum
sen:    fadd.s	fa1, fa1, ft1
        mul	t2, t2, t4	# O sinal só muda a cada duas iterações
comum:  addi	t0, t0, 1		# Incrementa o índice
        mul	t3, t3, t0	# É o fatorial para a próxima iteração
        fmul.s	ft0, ft0, ft3	# É o x^n
	bne	t1, t0, rep
fim:    beqz	a0, ninv
        fneg.s	fa0, fa0
ninv:   lw	ra, 0(sp)
        addi	sp, sp, 4
        ret

norm:	flw	ft0, DOIS_PI, t0
	fdiv.s	ft1, fa0, ft0	# ft7 = fa0 / (2π)
	fcvt.w.s	t6, ft1		# t6 = floor(fa0 / (2π))
	fcvt.s.w	ft1, t6
	fmul.s	ft1, ft1, ft0	# ft7 = t6 * (2π)
	fsub.s	fa0, fa0, ft1	# fa0 = fa0 - t6*(2π)
	flw	ft0, PI_2, t0
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