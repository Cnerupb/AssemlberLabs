.data
filename:   .string "C:/Users/alexl/Assembler/AssemlberLabs/pr6/random_numbers.txt"    # ���� �����
array_size: .word 25                        # ������ �������
array:      .space 100                      # ������ ��������� ����� (25 ����� �� 4 �����)
new_line:    .string  "\n"

.text
.globl _start

# SysCalls https://github.com/TheThirdOne/rars/wiki/Environment-Calls

_start:
    # ��������� ��������� ����� � ������ �� � ������
    li      t0, 25           # ���������� ����� ��� ���������
    la      t1, array        # ��������� �� ������ �������
    
    # �������� �����
    li      a7, 1024
    la      a0, filename
    li      a1, 1
    ecall
    mv      s0, a0
    
    

generate_random_loop:
    li      a7, 41           # ��������� ����� RandInt
    li      a0, 1            # ���� ��� ��������� ������ ���������� �����
    ecall

    li      a7, 1
    ecall                    # PrintInt

    sw      a0, 0(t1)        # ������ ���������� ����� � ������
    
    li      a7, 4
    la      a0, new_line
    ecall
    
    addi    t1, t1, 4        # ������� � ���������� �������� �������
    addi    t0, t0, -1       # ���������� ��������
    bnez    t0, generate_random_loop

    # ������ ������� � ����
    mv      a0, s0           # �������� ����������
    la      a1, array        # ��������� �� ������ ��� ������
    li      a2, 100          # ������ ������ (25 * 4 �����)
    li      a7, 64           # ��������� ����� write
    ecall

    # �������� �����
    mv      a0, s0           # �������� ����������
    li      a7, 57           # ��������� ����� close
    ecall

    # ���������� ���������
    li      a7, 93           # ��������� ����� exit
    li      a0, 0            # ��� ���������� ���������
    ecall