.data
	matrix: 
	    .word 1, 2, 3, 4    # первая строка
	    .word 5, 6, 7, 8    # вторая строка
	    .word -9, 10, -11, 12  # третья строка
	new_line:  
		.string "\n"

.text
.globl _start
_start:
	li a1, 0		  # счетчик строк
	li a2, 3                  # кол-во строк в матрице
	li a3, 0		  # счетчик столбцов
	li a4, 4		  # кол-во столбцов в матрице

iterate_rows:
	li a3, 0
	bne a1, a2, iterate_cols
	
	j print_result

iterate_cols:
	li t0, 4		  # размер одного целого числа
	mul t1, a1, a2	  	  # t1 = row_index*row_len
	mul t1, t1, t0		  # t1 = row_index*row_len*4 <- вычисляем адресс первого столбца строки row_index
	li t2, 4
	mul t2, t2, a3		  # t2 = 4*col_index
	
	li t3, 4
	mul t3, t3, a1		  # t3 = 4*row_index
	add t1, t1, t2	  	  # t1 = t1 + 4*col_index <- высчитываем адресс текущего столбца
	add t1, t1, t3		  # t1 = t1 + 4*row_index
	li t2, 0
	li t3, 0
	
	la t2, matrix		  # загружаем базовый адресс матрицы в t2
	add t2, t2, t1		  # адресс текущего элемента
	lw t5, 0(t2)		  # загружаем элемент матрицы в a5
	
	# печать элемента
	mv   a0, t5	           # Переменная Х
	li   a7, 1                 # Системный вызов write
	ecall                      # Выводим результат
    	
    	addi a3, a3, 1		   # col_index++
    	bne a3, a4, iterate_cols   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
    	j iterate_rows
        
print_result:
	# Завершаем программу
    	li a7, 10               # Системный вызов exit
    	ecall
	
