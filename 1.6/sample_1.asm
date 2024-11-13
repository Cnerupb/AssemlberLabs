.data
	matrix: 
	    .word 1, 2, 3, 4    # ������ ������
	    .word 5, 6, 7, 8    # ������ ������
	    .word -9, 10, -11, 12  # ������ ������
	new_line:  
		.string "\n"

.text
.globl _start
_start:
	li a1, 0		  # ������� �����
	li a2, 3                  # ���-�� ����� � �������
	li a3, 0		  # ������� ��������
	li a4, 4		  # ���-�� �������� � �������

iterate_rows:
	li a3, 0
	bne a1, a2, iterate_cols
	
	j print_result

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
	
	la t2, matrix		  # ��������� ������� ������ ������� � t2
	add t2, t2, t1		  # ������ �������� ��������
	lw t5, 0(t2)		  # ��������� ������� ������� � a5
	
	# ������ ��������
	mv   a0, t5	           # ���������� �
	li   a7, 1                 # ��������� ����� write
	ecall                      # ������� ���������
    	
    	addi a3, a3, 1		   # col_index++
    	bne a3, a4, iterate_cols   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
    	j iterate_rows
        
print_result:
	# ��������� ���������
    	li a7, 10               # ��������� ����� exit
    	ecall
	
