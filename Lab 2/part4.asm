.data

ArraySpace: .space 20
BData:      .word 1, 2, 4, 8, 16

.text


main:
	la t0 ArraySpace  # initiliaze space for A
	la t1 BData	# loading B
	li t3 0  # i 
	li t4 5
	li t5 0  # temp mem for A
	
	
	forloop:
        bge t3 t4 nextSection
	slli t5 t3 2          # Contains the necessary shift for the index of both array
	add  s0 t0 t5
	add  s1 t1 t5
	lw t5 0(s1)
	addi t6 t5 -1
	sw t6 0(s0)
	addi t3 t3 1
	j forloop
	
	nextSection:
	addi t3 t3 -1
	sub t5 t5 t5      # Reinitialize shift to zero
	
	whileLoop:
	blt t3 zero exit
	slli t5 t3 2
	add s0 t0 t5
	add s1 t1 t5
	lw  s3 0(s0)
	lw  s4 0(s1)
	add s3 s3 s4
	slli s3 s3 1
	sw s3 0(s0)
	addi t3 t3 -1
	j whileLoop

	exit:
	li a7 10
	ecall
	
	
	
	 
	
	


