.data
hello: .ascii "Hello world"

.text
.globl _start
_start:
	# Print hello world to the console
	la a0, hello
	li a7, 4
	ecall
	
	# Exit system call
	li a0, 2
	li a7, 10
	ecall

