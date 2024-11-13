.data
	matrixA: 
	    	.word 1, 2, 3, 4    # ������ ������
	    	.word 9, 5, 7, 4    # ������ ������
	    	.word -9, 10, -11, 8  # ������ ������
	matrixB:
		.word 0, 0, 0, 0
		.word 0, 0, 0, 0
		.word 0, 0, 0, 0
	max_row_index:
		.word 1
	prompt_matrix_a:
		.string "Matrix A:\n"
	prompt_matrix_b:
		.string "Matrix B:\n"
	new_line:
		.string "\n"
	white_space:
		.string " "

.text
.globl _start
_start:
	li a1, 0		  # ������� �����
	li a2, 3                  # ���-�� ����� � �������
	li a3, 0		  # ������� ��������
	li a4, 4		  # ���-�� �������� � �������
	li a5, 0		  # ����� ��������� ������
	li a6, 0		  # ������������ ����� ��������� ������
	li t5, 0		  # ������ ������ � ����.������ ���������
	
	# ����� � ������� "Matrix A:"
	la a0, prompt_matrix_a
	li a7, 4
	ecall
	

iterate_rows:
	bgt a5, a6, update_max_row	# ������ ������ ��������� �� �������� ����� ���������
	li a3, 0		  # ���������� ������� ��������
	li a5, 0		  # ���������� ����� ��������� ������
	bne a1, a2, iterate_cols
	
	j fill_b_matrix

iterate_cols:
	li t0, 4		  # ������ ������ ������ �����
	mul t1, a1, a2	  	  # t1 = row_index*row_len
	mul t1, t1, t0		  # t1 = row_index*row_len*4 <- ��������� ������ ������� ������� ������ row_index
	li t2, 4
	mul t2, t2, a3		  # t2 = 4*col_index
	li t3, 4
	mul t3, t3, a1		  # t3 = 4*row_index
	add t1, t1, t2	  	  # t1 = t1 + 4*col_index <- ����������� ������ �������� �������
	add t1, t1, t3		  # t1 = t1 + 4*row_index
	li t2, 0
	li t3, 0
	
	la t2, matrixA		  # ��������� ������� ������ ������� � t2
	add t2, t2, t1		  # ������ �������� ��������
	lw t4, 0(t2)		  # ��������� ������� ������� � t4
	
	# ������ ��������
	mv   a0, t4	           # ���������� �
	li   a7, 1                 # ��������� ����� write
	ecall                      # ������� ���������
	# ������ �������
	la a0, white_space
	li a7, 4
	ecall
	
	# ���������� �������� � ����� ������� ������
	add a5, a5, t4
    	
    	addi a3, a3, 1		   # col_index++
    	bne a3, a4, iterate_cols   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
	# ����� ������� �������� ������
	la a0, new_line
	li a7, 4
	ecall
    	
    	j iterate_rows

update_max_row:
	mv a6, a5		# ��������� ������������ ����.�����
	li t6, 1
	sub a1, a1, t6
	mv t5, a1		# � t5 ���������� ������ ������ � ���� ������ ���������
	add a1, a1, t6
	
	j iterate_rows

fill_b_matrix:
	li a1, 0		  # ������� �����
	li a2, 3                  # ���-�� ����� � �������
	li a3, 0		  # ������� ��������
	li a4, 4		  # ���-�� �������� � �������

rows_loop:
	li a3, 0		  # ���������� ������� ��������
	bne a1, a2, cols_loop
	j print_matrix_b

cols_loop:
	# ������� � t0 ������� ������ �������� ������������ ���� ������� �
	li t0, 4		  # ������ ������ ������ �����
	mul t1, a1, a2	  	  # t1 = row_index*row_len
	mul t1, t1, t0		  # t1 = row_index*row_len*4 <- ��������� ������ ������� ������� ������ row_index
	li t2, 4
	mul t2, t2, a3		  # t2 = 4*col_index
	li t3, 4
	mul t3, t3, a1		  # t3 = 4*row_index
	add t1, t1, t2	  	  # t1 = t1 + 4*col_index <- ����������� ������ �������� �������
	add t1, t1, t3		  # t1 = t1 + 4*row_index
	mv t0, t1		  # � t0 ���������� ������ ��������
	li t1, 0
	li t2, 0
	li t3, 0
	# ������� � t4 ������ �������� ������������ ������������ ������ � ������� �
	li t1, 4
	mul t2, t5, a2		  # t2 = max_row_index*row_len
	mul t2, t2, t1		  # t2 = max_row_index*row_len*4
	li t3, 4
	mul t3, t3, a3		  # t3 = 4*col_index
	li t4, 4
	mul t4, t4, t5		  # t4 = 4*max_row_index
	add t1, t2, t3	  	  # t1 = t1 + 4*col_index <- ����������� ������ �������� �������
	add t1, t1, t4		  # t1 = t1 + 4*max_row_index
	mv t6, t1		  # � t6 ���������� ������ �������� �� t1
	li t1, 0
	li t2, 0
	li t3, 0
	li t4, 0
	
	# �������� ������� �� K-� ������ ������� �
	la t1, matrixA		  # ��������� ������� ������ �������  A � t1
	add t1, t1, t6		  # ������ �������� �������� ������� A � K-� ������
	
	lw t4, 0(t1)         # � t4 ��������� ������� �� ��������� ������� A � K-� ������
	
	# �������� ������� �������� �� ������� A � B
	la t1, matrixA		  # ��������� ������� ������ �������  A � t1
	la t2, matrixB		  # ��������� ������� ������ �������  B � t2
	add t1, t1, t0		  # ������ �������� �������� ������� A
	add t2, t2, t0		  # ������ �������� �������� ������� B
	
	lw t3, 0(t1)         # � t3 ��������� ������� �� ��������� ������� A
	
	# � t3 ��������� ������� �������� �� ������� � �������� ������� � ��������� ������� � �-�� �������
	div t3, t3, t4  	  # t3 = t3 / t4
	
    	sw t3, 0(t2)         # ��������� ������� � ������� ������ B
	
	addi a3, a3, 1		   # col_index++
    	bne a3, a4, cols_loop   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
    	j rows_loop

print_matrix_b:
	li a1, 0		  # ������� �����
	li a2, 3                  # ���-�� ����� � �������
	li a3, 0		  # ������� ��������
	li a4, 4		  # ���-�� �������� � �������
	
	# ����� � ������� "Matrix B:"
	la a0, prompt_matrix_b
	li a7, 4
	ecall
	
print_rows:
	li a3, 0		  # ���������� ������� ��������
	bne a1, a2, print_cols
	j end_program

print_cols:
	li t0, 4		  # ������ ������ ������ �����
	mul t1, a1, a2	  	  # t1 = row_index*row_len
	mul t1, t1, t0		  # t1 = row_index*row_len*4 <- ��������� ������ ������� ������� ������ row_index
	li t2, 4
	mul t2, t2, a3		  # t2 = 4*col_index
	li t3, 4
	mul t3, t3, a1		  # t3 = 4*row_index
	add t1, t1, t2	  	  # t1 = t1 + 4*col_index <- ����������� ������ �������� �������
	add t1, t1, t3		  # t1 = t1 + 4*row_index
	mv t0, t1
	li t1, 0
	li t2, 0
	li t3, 0
	
	la t1, matrixB		  # ��������� ������� ������ �������  B � t2
	add t1, t1, t0		  # ������ �������� �������� ������� B
	lw t2, 0(t1)         # ��������� ������� �� ������� B
	
	# ������ ��������
	mv   a0, t2	           # ���������� �
	li   a7, 1                 # ��������� ����� write
	ecall                      # ������� ���������
	# ������ �������
	la a0, white_space
	li a7, 4
	ecall
    	
    	addi a3, a3, 1		   # col_index++
    	bne a3, a4, print_cols   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
	# ����� ������� �������� ������
	la a0, new_line
	li a7, 4
	ecall
    	
    	j print_rows
	

end_program:
	# ��������� ���������
    	li a7, 10               # ��������� ����� exit
    	ecall
	
