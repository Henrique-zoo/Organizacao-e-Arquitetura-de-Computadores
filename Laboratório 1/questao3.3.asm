.data
PI_2:	 .float  1.5707963
PI:	 .float  3.1415926
DOIS_PI:   .float  6.2831853
N:         .word   8
x:         .float  1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
X_real:    .float  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
X_imag:    .float  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

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
          jal      DFT
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