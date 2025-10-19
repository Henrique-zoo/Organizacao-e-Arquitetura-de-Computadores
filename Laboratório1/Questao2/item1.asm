.data
v:
        .word 9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78,54,23,1,54,2,65,3,6,55,31

.text
        jal	main
        li	a7, 10
        ecall
        
SHOW:   mv t0,a0
        mv t1,a1
        mv t2,zero
loop1:  beq t2,t1,fim1
        li a7,1
        lw a0,0(t0)
        ecall
        li a7,11
        li a0,9 # print(tab)
        ecall
        addi t0,t0,4
        addi t2,t2,1
        j loop1
fim1:   li a7,11
        li a0,10
        ecall #print(\n)
        ret
swap:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        lw      a5,-40(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a5,0(a5)
        sw      a5,-20(s0)
        lw      a5,-40(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a4,a4,a5
        lw      a5,-40(s0)
        slli    a5,a5,2
        lw      a3,-36(s0)
        add     a5,a3,a5
        lw      a4,0(a4)
        sw      a4,0(a5)
        lw      a5,-40(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a4,-20(s0)
        sw      a4,0(a5)
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
sort:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      zero,-20(s0)
        j       .L6
.L10:
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-24(s0)
        j       .L7
.L9:
        lw      a1,-24(s0)
        lw      a0,-36(s0)
        call    swap
        lw      a5,-24(s0)
        addi    a5,a5,-1
        sw      a5,-24(s0)
.L7:
        lw      a5,-24(s0)
        blt     a5,zero,.L8
        lw      a5,-24(s0)
        slli    a5,a5,2
        lw      a4,-36(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        lw      a5,-24(s0)
        addi    a5,a5,1
        slli    a5,a5,2
        lw      a3,-36(s0)
        add     a5,a3,a5
        lw      a5,0(a5)
        bgt     a4,a5,.L9
.L8:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L6:
        lw      a4,-20(s0)
        lw      a5,-40(s0)
        blt     a4,a5,.L10
        nop
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
main:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        la      a0,v
        li      a1,30
        call    SHOW
        la      a0,v
        li      a1,30
        call    sort
        la      a0,v
        li      a1,30
        call    SHOW
        li      a5,0
        mv      a0,a5
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra