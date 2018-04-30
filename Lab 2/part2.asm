
.data

.text

main:
	li t1, 10
	li t2, 9
	li t3, 6
	li a1, 0
	
	slt t4, t1,t2
	li t0, 5
	slt t5, t0, t3
	
	bne t4, t5 elseif
	li a1, 1
	j case1
	
elseif:
 	slt t4, t2, t1
 	beq t4, zero  else
 	addi t3, t3,1
 	addi t0, zero,7
 	bne t3, t0 else
 	li a1, 2
 	j case1
 	
 else:
 	li a1, 3
 	j case1
 	
 case1:
 	li t1, 1
 	bne a1,t1 case2
 	li a1, -1
 	j exit
 case2:
 	li t1, 2
 	bne a1, t1 case3
 	li a1, -2
 	j exit
  case3:
 	li t1, 3
 	bne a1, t1 casedefault
 	li a1, -3
 	j exit
  casedefault:
 	li a1, 0
 	j exit
 
 exit:
 	li a7,10
 	ecall
 
 	
 	
 	
	
	