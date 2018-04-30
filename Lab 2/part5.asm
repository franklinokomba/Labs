.data

a: .word 4
b: .word 4
c: .word 4

.text


main:


      la t2 a   
      la t3 b
      la t4 c
      
      li t0 5  
      li t1 10
      
      mv a0 t0
      jal AdditUp
      mv t2 a0
      
      mv a0 t1
      jal AdditUp
      
      mv t3 a0
      add t4 t2 t3
      
      
     li a7 10
     ecall
      


AdditUp:
      
      addi sp sp -8
      sw t0 0(sp)
      sw t1 4(sp)
      
      li t0, 0 # i
      li t1, 0  # x
      forLoop:
      bge t0 a0 returnSection
      add t1 t1 t0
      addi t1 t1 1
      addi t0 t0 1
      j forLoop
      
      returnSection:
      mv a0 t1
      lw t0 0(sp)
      lw t1 4(sp)
      addi sp sp 8
      ret
	