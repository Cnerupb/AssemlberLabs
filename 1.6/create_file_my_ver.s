.data
	filename:   	.string		"C:/Users/alexl/Assembler/AssemlberLabs/1.6/output.txt"    # ���� �����
	buffer:		.string 	"12 24 55 66 34 68 93 43 23 12 9 5"

.text
.globl _start

# SysCalls https://github.com/TheThirdOne/rars/wiki/Environment-Calls

_start:
open_file:
	# ������� ����
	li a7, 1024		# ��������� ����� ��� �������� ����� (sys_open)
	la a0, filename		# ���� �� �����
	li a1, 1		# ���� ��� ������ (O_WRONLY)
	li a2, 0644		# ����� �������
	ecall
	mv s0, a0		# ��������� ���������� ����� � s0

write_string:
	# �������� � ����
	li a7, 64		# ��������� ����� ��� ������ (sys_write)
	mv a0, s0		# ���������� �����
	la a1, buffer		# ����� � ������� ��� ������
	li a2, 33		# ���-�� ���� ��� ������
	ecall

close_file:
	# �������� �����
	li a7, 57		# ��������� ������ ��� �������� ����� (sys_close)
	mv a0, s0		# ���������� �����
	ecall

end_program:
    # ���������� ���������
    li      a7, 93           # ��������� ����� exit
    li      a0, 0            # ��� ���������� ���������
    ecall
    