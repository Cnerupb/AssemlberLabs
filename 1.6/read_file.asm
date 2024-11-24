.data
	filename: 	.string "output.txt"		# ���� �� �����
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

end_program:
	li a7, 93			# ��������� ����� ��� ������ (sys_exit)
	li a0, 0			# ��� ��������
	ecall
	