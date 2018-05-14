
.data

.text

main:
	
	li a0 3
	jal fib
	mv s1 s0
	
	li a0 10
	jal fib
	mv s2 s0
	
	li a0 20
	jal fib
	mv s3 s0
	
	
	li a7 10
	ecall

fib: 
   li t1 1
   
   bgt a0 t1 fibrecurse
   mv s0 a0
   
   ret
   
 fibrecurse:
   addi sp sp -12
   sw  ra, 0(sp)
   
    sw  a0, 4(sp)
    
    addi a0, a0, -1
    jal fib
    
    lw  a0, 4(sp)
    sw  s0, 8(sp)
    
    addi a0, a0, -2
    jal fib
    
    lw  t0, 8(sp)
    add s0, t0,s0
    
    lw  ra, 0(sp)
    addi sp, sp,12
    
    ret
    
    
     
