.data
	arr: .word 10
	e0: .word 0

.text
loop:
	li t1, e0
	beq t1, 40
	
	lw t0, e0(s0)
	
	mv a0, t0
	li a7, 1
	ecall
	
	add e0, e0, 4
	jal e0, loop
