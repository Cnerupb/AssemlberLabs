.data
	filename: 	.string "output.txt"		# ���� �� �����
	white_space:	.string " "			# ������ �������
	new_line:	.string "\n"			# ������ ����� ������
	numbers:	.word 48			# 12 ����� �� 4 ����� (48 ���� �����)
	buffer: 	.space 100			# ����� ��� ������ ������
	

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
	li a2, 100			# ������������ ���-�� ���� ��� ������
	ecall
	mv s1, a0			# ��������� ���-�� ����������� ���� � s1

close_file:
	# ������� ����
	li a7, 57			# ��������� ����� ��� �������� ����� (sys_close)
	mv a0, s0			# ���������� �����
	ecall

print_string:
	# ������� ������ � �������
	li a7, 64			# ��������� ����� sys_write
	li a0, 1			# ���������� ����� ��� ������������ ������ (stdout)
	la a1, buffer			# ����� � �������
	mv a2, s1			# ���-�� ���� ��� ������
	ecall

parse_buffer:
	# ����������� �������� � �����
	la t0, buffer			# ����� ������
	la t1, numbers			# ����� ������� �����
	li t6, 0			# ������� �����

parse_loop:
	# ���� �����������
	lb t2, 0(t0)			# ��������� ������� ������
	
	li t3, 0
	beq t2, t3, end_parse_loop	# ���� ����� ������, �� ��������� ������� � ���������� ��������� �����
	
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
end_program:
	li a7, 93			# ��������� ����� ��� ������ (sys_exit)
	li a0, 0			# ��� ��������
	ecall
	
