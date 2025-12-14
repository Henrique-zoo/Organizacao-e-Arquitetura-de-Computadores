.data
PI_2:	    .float  1.5707963
PI:         .float  3.1415926
DOIS_PI:    .float  6.2831853
N:          .word   44
x:          .float  1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
X_real:     .float  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
X_imag:     .float  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

str_x:     .string "x[n]\tX[k]\n"
tab:       .string "\t"
i:         .string "i\n"
mais:      .string "+"

.text
	la       s0, x
          la       s1, X_real
          la       s2, X_imag
          lw       s3, N
          li       s4, 0
    
          mv       a0, s0
          mv       a1, s1
          mv       a2, s2
          mv       a3, s3
          
          csrr     t2, 3074        # lê número de instruções antes
          csrr     t3, 3073        # lê tempo antes (ms)
          mv       s7, t2
          mv       s8, t3
          
          jal      DFT
          
          csrr     t4, 3073        # lê tempo depois
    	  csrr     t5, 3074        # lê número de instruções depois

  	  sub      s5, t4, s8      # tempo_exec = t4 - t3
  	  sub      s6, t5, s7      # instruções_exec = t5 - t2
  	  
  	  # imprime resultados
  	  li       a7, 4
  	  la       a0, str_x
  	  ecall

  	  li       a7, 1
  	  mv       a0, s5
  	  ecall    # imprime tempo (ms)

  	  li       a7, 4
  	  la       a0, tab
  	  ecall

  	  li       a7, 1
  	  mv       a0, s6
  	  ecall    # imprime número de instruções

  	  li       a7, 4
  	  la       a0, i
  	  ecall
  	  
          li       a7, 4
          la       a0, str_x
          ecall
loop:	li       a7, 2
          flw      fa0, 0(s0)
          ecall		# print(x[n])
          li       a7, 11
          lb       a0, tab
          ecall		# print("\t")
          li       a7, 2
          flw      fa0, 0(s1)
          ecall		# print(Re{z})
          flw      fa0, 0(s2)
          fcvt.s.w ft0, zero
          fge.s    t1, fa0, ft0
          beqz     t1, negativo
          li       a7, 11
          lb       a0, mais
          ecall		# print("+")
negativo:	li       a7, 2
          ecall		# print(Im{z})
          li       a7, 4
          la       a0, i
          ecall		# print("i\n")
          addi     s0, s0, 4
          addi     s1, s1, 4
          addi     s2, s2, 4
          addi     s4, s4, 1
          bne      s4, s3, loop
    
          li       a7, 10
          ecall
          
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
          fdiv.s   ft7, fa0, ft6         # ft7 = fa0 / (2?)
          fcvt.w.s t6, ft7               # t6 = floor(fa0 / (2?))
          fcvt.s.w ft7, t6
          fmul.s   ft7, ft7, ft6         # ft7 = t6 * (2?)
          fsub.s   fa0, fa0, ft7         # fa0 = fa0 - t6*(2?)
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
	fgt.s	t0, fa0, ft0	# if fa0 > ?/2: t0 = 1
	beqz	t0, elif
	j	subt
elif:	fneg.s	ft0, ft0		# ft0 = -?/2
	fneg.s	ft1, ft1		# ft1 = -?
	flt.s	t0, fa0, ft0	# if fa0 < -?/2: t0 = 1
	beqz	t0, else
subt:	fsub.s	fa0, ft1, fa0	# fa0 = ? - fa0 ou fa0 = -? - fa0
	li	a0, 1		# flag para inverter o cosseno
	j	return
else:	li	a0, 0
return:	ret