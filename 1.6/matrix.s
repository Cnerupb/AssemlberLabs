.data
	filename:    .string "C:/Users/alexl/Assembler/AssemlberLabs/pr6/random_numbers.txt"  # ���� �����
	buffer:      .space 100           # ����� ��� ������ ������ �� �����
	matrix:      .word 100           # ������� (25 ��������� �� 4 �����)

.text
.global _start

# SysCalls https://github.com/TheThirdOne/rars/wiki/Environment-Calls

_start:
        # ��������� ���� �� ������
        la a0, filename           #zD ���� �����
        li a1, 0                  # ����� ������
        li a7, 1024               # syscall open
        ecall
        mv t0, a0                 # ��������� �������� ����������

        # ������ ������ �� ����� � �����
        mv a0, t0                 # ����������
        la a1, buffer             # ����� ������
        li a2, 100                # ������� ���� ���������
        li a7, 63                 # syscall Read
        ecall

        # ��������� ����
        mv a0, t0                 # �������� ����������
        li a7, 57                 # syscall close
        ecall

        # ����������� ������ �� ������ � �������
        la t1, buffer             # ��������� �� �����
        li t2, 0                  # ������ ������
        li t3, 0                  # ������ �������
        la t4, matrix             # ��������� �� �������

parse_buffer:
        # ���� ��� ������ �������, ���������� ������ � ��������
        li t5, 25                 # ����� 25 ���������
        beq t2, t5, process_matrix

        lb t6, 0(t1)              # ��������� ������� �� ������
        sw t6, 0(t4)              # ��������� ������� � �������

        addi t1, t1, 4            # ������� ��������� ������
        addi t4, t4, 4            # ������� ��������� �������
        addi t2, t2, 1            # ����������� ������
        j parse_buffer

process_matrix:
        # ������ ������� ���������, ��������� ������ ��������� �� 0 ������ �����
        li t2, 0                  # ������� �����
        li t3, 0                  # ������� ��������

iterate_rows:
        # ���� ��� ������ ����������, ������� ���������
        li t0, 5                  # ������ ������� 5x5
        beq t2, t0, print_matrix

        li t3, 0                  # �������� ������� ��������

iterate_cols:
        # ���� ��� ������� � ������ ����������, ��������� � ��������� ������
        beq t3, t0, next_row

        # ������� ��� ���������
        add t4, t2, t3            # t4 = i + j
        li t5, 4                  # n - 1 (��� �������� ���������)
        beq t4, t5, skip_zero     # i + j == n - 1, �� ��������
        beq t2, t3, skip_zero     # i == j, �� ��������

        # �������� �������
        slli t6, t2, 2            # ������� ������ (t2 * 4)
        add t6, t6, t2            # t6 = t2 * 5 (����� ������� ��������)
        add t6, t6, t3            # ��������� ������� (������ �������� t2*5 + t3)
        slli t6, t6, 2            # �������� �� 4 (����� = 4 �����)
        la t5, matrix             # ��������� �� ������ �������
        add t5, t5, t6            # �������� ����� ��������
        sw zero, 0(t5)            # ���������� 0

skip_zero:
        addi t3, t3, 1            # ��������� � ���������� �������
        j iterate_cols

next_row:
        addi t2, t2, 1            # ��������� � ��������� ������
        j iterate_rows

print_matrix:
        li t2, 0                  # �������� ������� �����

print_rows:
        beq t2, t0, exit          # ���� ��� ������ ��������, ���������� ���������

        li t3, 0                  # �������� ������� ��������

print_cols:
        beq t3, t0, next_print_row

        slli t6, t2, 2            # ������� ������ (t2 * 4)
        add t6, t6, t2            # t6 = t2 * 5 (����� ������� ��������)
        add t6, t6, t3            # ��������� ������� (������ �������� t2*5 + t3)
        slli t6, t6, 2            # �������� �� 4 (����� = 4 �����)
        la t1, matrix             # ��������� �� ������ �������
        add t1, t1, t6            # �������� ����� ��������
        lw a0, 0(t1)              # ��������� �������
        li a7, 1                  # syscall 1 - ����� �����
        ecall

        li a0, ' '                # ����� �������
        li a7, 11                 # syscall 11 - ����� �������
        ecall

        addi t3, t3, 1            # ��������� � ���������� �������
        j print_cols

next_print_row:
        li a0, 10                 # ����� ����� ������
        li a7, 11                 # syscall 11 - ����� �������
        ecall

        addi t2, t2, 1            # ��������� � ��������� ������
        j print_rows

exit:
        li a7, 10                 # syscall 10 - ���������� ���������
        ecall
