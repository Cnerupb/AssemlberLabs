.data
	buffer: 	.space 100			# ����� ��� ������ ������
	filename: 	.string "output.txt"		# ���� �� �����
	white_space:	.string " "			# ������ �������
	newline:	.string " Newline\n"		# ������ ����� ������
	numbers:	.word 48			# 12 ����� �� 4 ����� (48 ���� �����)
	

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
	# ����� ������� � �������
	li a7, 1
	mv a0, t6
	ecall
	# ������
	li a7, 11
	li a0, ' '
	ecall
	
	sw t6, 0(t1)			# ��������� ����� � ������ numbers
	li t6, 0			# �������� �����
	
	addi t0, t0, 1
	addi t1, t1, 4
	j parse_loop

end_parse_loop:
	# ����� ������� � �������
	li a7, 1
	mv a0, t6
	ecall

	sw t6, 0(t1)

	la t0, numbers			# ��������� ������ �������
	li t1, 12			# ���-�� ����� ��� ������

print_numbers_loop:
	lw t2, 0(t0)
	
	bnez t1, end_print_numbers_loop
	
	# ����� ����� � �������
	li a7, 1
	mv a0, t2
	ecall
	# ����� ������� �������
	li a7, 11
	li a0, ' '
	ecall

next_number_to_print:
	addi t0, t0, 4
	li a5, 1
	sub t1, t1, a5
	j print_numbers_loop

end_print_numbers_loop:
end_program:
	li a7, 93			# ��������� ����� ��� ������ (sys_exit)
	li a0, 0			# ��� ��������
	ecall