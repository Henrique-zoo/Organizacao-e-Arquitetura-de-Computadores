.text
DFT:      addi     sp, sp, -44
          fsw      fs0, 40(sp)
          fsw      fs1, 36(sp)
          fsw      fs2, 32(sp)
          fsw      fs3, 28(sp)
          fsw      fs4, 24(sp)
          fsw      fs5, 20(sp)
          sw       s0, 16(sp)
          sw       s1, 12(sp)
          sw       s2, 8(sp)
          sw       s3, 4(sp)
          sw       ra, 0(sp)	# Empilhando
          flw      fs0, DOIS_PI, t0
          fcvt.s.w ft0, a3
          fdiv.s   fs0, fs0, ft0
          li       s0, 0
          mv       s3, a0
for1:     fcvt.s.w fs1, s0
          fcvt.s.w fs4, zero
          fcvt.s.w fs5, zero
          mv       s2, s3
          li       s1, 0
for2:     flw      fs2, 0(s2)
          fcvt.s.w fs3, s1
          fmul.s   fs3, fs3, fs1         # n*k
          fmul.s   fa0, fs3, fs0         # n*k*(-2pi/N)
          la       t0, DOIS_PI
          flw      ft6, 0(t0)
          fdiv.s   ft7, fa0, ft6         # ft7 = fa0 / (2π)
          fcvt.w.s t6, ft7               # t6 = floor(fa0 / (2π))
          fcvt.s.w ft7, t6
          fmul.s   ft7, ft7, ft6         # ft7 = t6 * (2π)
          fsub.s   fa0, fa0, ft7         # fa0 = fa0 - t6*(2π)
          jal      SINCOS
          fmul.s   fa0, fa0, fs2         # x[n]*cos(n*k*(-2pi/N))
          fmul.s   fa1, fa1, fs2         # x[n]*sen(n*k*(-2pi/N))
          fadd.s   fs4, fs4, fa0
          fadd.s   fs5, fs5, fa1
          addi     s1, s1, 1
          addi     s2, s2, 4
          bne      s1, a3, for2
          fsw      fs4, 0(a1)
          fsw      fs5, 0(a2)
          addi     s0, s0, 1
          addi     a1, a1, 4
          addi     a2, a2, 4
          bne      s0, a3, for1
          flw      fs0, 40(sp)
          flw      fs1, 36(sp)
          flw      fs2, 32(sp)
          flw      fs3, 28(sp)
          flw      fs4, 24(sp)
          flw      fs5, 20(sp)
          lw       s0, 16(sp)
          lw       s1, 12(sp)
          lw       s2, 8(sp)
          lw       s3, 4(sp)
          lw       ra, 0(sp)
          addi     sp, sp, 44            # Desempilhando
          ret
          
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
rep:   	fcvt.s.w 	ft1, t2
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
	bne	t1, t0, rep
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
