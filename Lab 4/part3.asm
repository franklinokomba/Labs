
.data


.text

main:	
	li t0 0x4f302c85

	li t1 0x7a222578

	

	add s0 t0 t1
	
	li t0 0x4f302c85
	li t1 0x7a222578
	sub s1 t0 t1

	
	li t0 0x00000000
	addi s2 t0 0x000f
	
	
	li t0 0xffffffff
	li t1 0x00000000
	and s3 t0 t1
	
	li t0 0x00000000
	andi s4 t0 0xffffffff 
	
	
	li t0 0x00000000
	li t1 0xffffffff
	or s5 t0 t1

	li t0 0x00000000
	ori s6 t0 0xffffffff

	li t0 0xffffffff
	li t1 0x00000080
	sll s7 t0 t1

	srl s8 t0 t1


	li a7, 10

	ecall






