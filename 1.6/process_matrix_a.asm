.data
	filename: 	.string "output.txt"		# ���� �� �����
	white_space:	.string " "			# ������ �������
	newline:	.string "\n"			# ������ ����� ������
	prompt_buff:	.string "buffer: "
	prompt_nums:	.string "numbers: "
	prompt_mb:	.string "Matrix B: "
	buffer: 	.space 48			# ����� ��� ������ ������
	numbers:	.word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1	# 12 ����� �� 4 ����� (48 ���� �����)
	matrixB:	.word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1	# 12 ����� �� 4 �����
	

.text
.globl _start

_start:
open_file:
	# ������� ���� ��� ������
	li a7, 1024			# ��������� ����� ��� �������� ����� (sys_open)
	la a0, filename			# ��� �����
	li a1, 0			# ���� ��� ������ (O_RDONLY)
	li a2, 0			# ����� ������� (�� ������������ ��� ������)
	ecall
	mv s0, a0			# ��������� ���������� ����� � s0

read_string:
	# ��������� ������ �� �����
	li a7, 63			# ��������� ����� ��� ������ (sys_read)
	mv a0, s0			# ���������� �����
	la a1, buffer			# ����� ��� ������ ������
	li a2, 200			# ������������ ���-�� ���� ��� ������
	ecall
	mv s1, a0			# ��������� ���-�� ����������� ���� � s1

close_file:
	# ������� ����
	li a7, 57			# ��������� ����� ��� �������� ����� (sys_close)
	mv a0, s0			# ���������� �����
	ecall

print_string:
	li a7, 4
	la a0, prompt_buff
	ecall

	# ������� ��������� ������ � �������
	li a7, 64			# ��������� ����� sys_write
	li a0, 1			# ���������� ����� ��� ������������ ������ (stdout)
	la a1, buffer			# ����� � �������
	mv a2, s1			# ���-�� ���� ��� ������
	ecall
	
	# ����� ������� �������� ������
	li a7, 4
	la a0, newline
	ecall

parse_buffer:
	# ����������� �������� � �����
	la t0, buffer			# ����� ������
	la t1, numbers			# ����� ������� �����
	li t6, 0			# ������� �����

parse_loop:
	# ���� �����������
	lb t2, 0(t0)			# ��������� ������� ������
	
	beqz t2, end_parse_loop	# ���� ����� ������, �� ��������� ������� � ���������� ��������� �����
	
	li t3, ' '			# ��������� ������ �������
	beq t2, t3, next_number		# ���� ������� ������ - ������, �� ��������� � ���������� �����
	
	# ����������� � ���������� ����� � ����� �����
	li a5, '0'
	sub t2, t2, a5			# ����� = ����� ������� - ����� ������� ���� (31 - 30 = 1, 32 - 30 = 2, ...)
	li a5, 10
	mul t6, t6, a5			# �������� ����� �� 10
	add t6, t6, t2			# ��������� �����
	
	# ������� � ���������� �������
	addi t0, t0, 1			
	j parse_loop

next_number:
	sw t6, 0(t1)			# ��������� ����� � ������ numbers
	li t6, 0			# �������� �����
	
	addi t0, t0, 1
	addi t1, t1, 4
	j parse_loop

end_parse_loop:
	sw t6, 0(t1)
	
	li a7, 4
	la a0, prompt_nums
	ecall
	
	la t0, numbers			# ��������� ������ �������
	li t1, 0			# ��� �����
	li t2, 0			# ������� �����
	li t3, 12			# ����� �������

print_numbers_loop:
	# ������� ������ numbers ���� .word
	beq t2, t3, end_print_numbers_loop
	
	# ����� ����� � �������
	li a7, 1
	lw t1, 0(t0)
	mv a0, t1
	ecall
	# ����� ������� �������
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	
	addi t2, t2, 1
	j print_numbers_loop

end_print_numbers_loop:
	# ����� ������
	li a7, 4
	la a0, newline
	ecall

	la t0, numbers
	la t1, matrixB
	li t2, 0		# ��� ����������� �������
	li t3, 0
	li t4, 12

loop_1:
	# �������� ������� numbers � ������� B
	beq t3, t4, end_loop_1
	
	lw t2, 0(t0)			# ��������� ����� �� �������
	sw t2, 0(t1)			# ��������� � ������� B
	
	addi t0, t0, 4
	addi t1, t1, 4
	
	addi t3, t3, 1
	j loop_1
	
end_loop_1:
	# ����� � ������� "Matrix B:"
	li a7, 4
	la a0, prompt_mb
	ecall

	la t0, matrixB
	li t1, 0			# ��� ����������� �������
	li t2, 0			# ������� �����
	li t3, 12			# ����� �������

loop_2:
	# ����� ������� B
	beq t2, t3, end_loop_2
	
	# ����� ����� � �������
	li a7, 1
	lw t1, 0(t0)
	mv a0, t1
	ecall
	# ����� ������� �������
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	
	addi t2, t2, 1
	j loop_2

end_loop_2:
	j end_program
	la t0, matrixB
	li t1, 12
	

print_mb_loop_1:
	beqz t1, end_print_mb_loop_1
	
	# ������ �������
	li a7, 1
	lw t2, 0(t0)
	mv a0, t2
	ecall
	# ������
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	li a5, 1
	sub t1, t1, a5
	j print_mb_loop_1
	
end_print_mb_loop_1:
	la t0, numbers
	la t1, matrixB
	li t2, 0			# ������ ������
	li t3, 0			# ������ �������
	# � s0 ������ ���� ������
	li s2, 3			# ���-�� �����
	li s3, 4			# ���-�� ��������

row_loop_3:
	beq t2, s2, end_loop_3
	
	li t3, 0
	j col_loop_3

col_loop_3:
	beq t3, s3, next_row_3
	
	# ����������� ������ �������� K-� ������
	li t4, 4
	mv t5, s0			# t5 = max_row_index
	mul t5, t5, t4			# 4*max_row_index
	add t5, t5, t3			# 4*max_row_index + col_index
	mul t5, t5, t4			# (4*i + j)*4
	
	la t4, numbers
	add t4, t4, t5
	
	lw t4, 0(t4)			# ��������� � t4 ������� K-� ������
	lw t5, 0(t0)			# � t5 ��������� ������� ������� � ������� �
	
	div t5, t5, t4			# ����� ������� �� ������� �� ������� �� ������� �� K-� ������
	
	sw t5, 0(t1)			# ���������� ������� � ������� B
	
	addi t0, t0, 4
	addi t1, t1, 4
	addi t3, t3, 1
	j col_loop_3
	

next_row_3:
	addi t0, t0, 4			# ��������� � ���������� �������� ������� A
	addi t1, t1, 4			# ��������� � ���������� �������� ������� B
	addi t2, t2, 1
	j row_loop_3

end_loop_3:
	# ����� ������
	li a7, 4
	la a0, newline
	ecall

	la t0, matrixB
	li t1, 0			# ��� ����������� �������
	li t2, 0			# ������ ������
	li t3, 0 			# ������ �������

row_loop_4:
	beq t2, s2, end_loop_4
	
	li t3, 0
	j col_loop_4

col_loop_4:
	beq t3, s3, next_row_4
	
	# ������ ��������
	lw t6, 0(t0)
	li a7, 1
	mv a0, t6
	ecall
	# ������
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	addi t3, t3, 1
	j col_loop_4

next_row_4:
	# ����� ������
	li a7, 4
	la a0, newline
	ecall

	addi t0, t0, 4
	addi t2, t2, 1
	j row_loop_4

end_loop_4:
end_program:
	li a7, 93			# ��������� ����� ��� ������ (sys_exit)
	li a0, 0			# ��� ��������
	ecall
