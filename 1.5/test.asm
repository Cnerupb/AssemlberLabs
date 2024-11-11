.data
hello: .ascii "Hello world"

.text
.globl _start
_start:
	# Print hello world to the console
	li t0, 2
	li t1, 2
	rem t2, t0, t1
	mv a0, t2
	li a7, 1
	ecall
	
	li t0, -2
	li t1, 2
	rem t2, t0, t1
	mv a0, t2
	li a7, 1
	ecall
	
	# Exit system call
	li a0, 2
	li a7, 10
	ecall