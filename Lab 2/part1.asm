
.data
newline: .asciiz "\n"
.text


main:
	li t1, 15
	li t2, 10
	li t3, 5
	li t4, 2
	li t5, 18
	li t6, -3
	li t0, 0
	
	sub a1, t1, t2

	mul a2, t3, t4

	sub a3, t5, t6

	div a4, t1, t3

        add a0, a1,a2
        add a0, a0, a3
        add a0, a0, a4
        
        li a7, 1
        ecall 
        
	li a7, 10
	ecall
	