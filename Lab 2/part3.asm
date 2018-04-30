
.data
i: .word 0
z: .word 2
.text
	

main:	
	
	la t0 i
	li t4 100
	la  s0 z
	
	forloop: slti t1, t0 20
	beq t1, zero dowhile
	
	addi t0 t0 2
	addi s0 s0 1
	
	j forloop
	
	dowhile: 
	addi s0 s0 1
	bge s0, t4 while
	j dowhile 
	
	while: ble t0 zero exit
	addi s0 s0 -1
	addi t0 t0 -1
	j while
	
	exit: 
	li a7 10
	ecall
	
