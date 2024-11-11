.data
	prompt_a:  .string "Enter A: "
    	prompt_x:  .string "Enter X: "
   	result_1:  .string "Y for X = "
    	result_2:  .string " is: "
    	new_line:  .string "\n"

.text
.globl _start
_start:
	# ��������� �
    	la   a0, prompt_a          # ��������� ������ ������� � a0
    	li   a7, 4                 # ��������� ����� write
    	ecall                      # ����� ���� ��� ������
    	li   a7, 5                 # ��������� ����� read integer
    	ecall                      # ������ ������ ����� A
    	mv   s0, a0                # ��������� A � s0
    	
    	# �������� �������� X
	la   a0, prompt_x          # ��������� ������ ������� � a0
	li   a7, 4                 # ��������� ����� write
    	ecall                      # ����� ���� ��� ������
    	li   a7, 5                 # ��������� ����� read integer
    	ecall                      # ������ ������ ����� X
   	mv   s1, a0                # ��������� ��������� X � s1
   	
   	# � � s1 ����� ����������������, ������� ��������� �������� � s2
   	mv   s2, a0
   	
loop:
calc_y1:
	# y1 = 4 - X, ���� |X| < 3; X - A, � ��������� �������
	mv t0, s1                # �������� X � t0
	blt t0, zero, negate_x   # ���� X < 0, �� X = |X| � �������� t0
	
	li t1, 3
	blt t0, t1, calc_y1_fc 	 # ���� |X| < 3, �� ������� y1 �� ������� ������
	
	j calc_y1_sc		 # ����� �� �������

negate_x:
    	neg  t0, t0                # ������ X �������������
    	li t1, 3
	blt t0, t1, calc_y1_fc 	 # ���� |X| < 3, �� ������� y1 �� ������� ������
	
	j calc_y1_sc
	

calc_y1_fc:
	li t1, 4
	li t2, 0
	sub t2, t1, s1		# t3 = 4 - X
	
	j calc_y2

calc_y1_sc:
	li t2, 0
	add t2, s1, s0		 # t3 = A + X
	
	j calc_y2


calc_y2:
    	# y2 = 2, ���� X - ������; A + 2 - � ��������� �������
    	mv t0, s1	# �������� X � t0
    	li t1, 2	# � t3 �������� 2
    	li t4, 0
    	rem t4, t0, t1	# � t4 ������� �� ������� X �� 2
    	beq t4, zero, calc_y2_fc	# ���� X - ������, ������� �� ������� ������
	
    	j calc_y2_sc

calc_y2_fc:
	li t3, 2	# t3 = 2
	
	j calc_y

calc_y2_sc:
	li t1, 2
	li t3, 0
	add t3, s0, t1	# t3 = A + 2
	
	j calc_y
	
calc_y:
    # Y = y1 + y2
    add  t4, t2, t3

    # ����� ���������� ===============================================
    la   a0, result_1          # ��������� �������� ������ ����������
    li   a7, 4                 # ��������� ����� write
    ecall                      # ������� ���������


    mv   a0, s1	               # ���������� �
    li   a7, 1                 # ��������� ����� write
    ecall                      # ������� ���������
    
    la   a0, result_2          # ��������� is:
    li   a7, 4                 # ��������� ����� write
    ecall                      # ������� ���������
    
    
    mv   a0, t4                # ������ �������� - Y
    li   a7, 1                 # ��������� ����� write
    ecall                      # ������� ���������
    
    la   a0, new_line          # ��������� new_line
    li   a7, 4                 # ��������� ����� write
    ecall                      # ������� ���������
    # ================ ===============================================

    # ����������� X �� 1
    li   t0, 1                 # t5 = 1
    add  s1, s1, t0            # ����������� X �� 1

    # ���������, �������� �� X + 9
    li   t5, 10                 # t5 = 9
    add  t6, s2, t5            # t6 = X + 9
    blt  s1, t6, loop          # ���������, ���� X <= X + 9

    # ���������� ���������
    li   a7, 93                # ��������� ����� ��� ����������
    ecall                      # ��������� ���������
	