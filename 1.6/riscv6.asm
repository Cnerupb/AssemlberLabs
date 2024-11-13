.data
	matrixA: 
	    	.word 10, 6, 8#, 4    # первая строка
	    	.word 9, 5, 7#, 4    # вторая строка
	    	#.word -9, 10, -11, 8  # третья строка
	matrixB:
		.word 0, 0, 0#, 0
		.word 0, 0, 0#, 0
		#.word 0, 0, 0, 0
	matrixC:
		.float 0, 0, 0#, 0
		.float 0, 0, 0#, 0
		#.float 0, 0, 0, 0
	prompt_matrix_a:
		.string "Matrix A:\n"
	prompt_matrix_b:
		.string "Matrix B:\n"
	prompt_filling_matrix_b:
		.string "Filling Matrix B:\n"
	new_line:
		.string "\n"
	white_space:
		.string " "

.text
.globl _start
_start:
	li a1, 0		  # счетчик строк
	li a2, 2                  # кол-во строк в матрице
	li a3, 0		  # счетчик столбцов
	li a4, 3		  # кол-во столбцов в матрице
	li a5, 0		  # сумма элементов строки
	li a6, 0		  # запоминаемая сумма элементов строки
	li t5, 0		  # индекс строки с макс.суммой элементов
	
	# Вывод в консоль "Matrix A:"
	la a0, prompt_matrix_a
	li a7, 4
	ecall
	

iterate_rows:
	bgt a5, a6, update_max_row	# каждую строку проверяем на максимум суммы элементов
	li a3, 0		  # сбрасываем счетчик столбцов
	li a5, 0		  # сбрасываем сумму элементов строки
	bne a1, a2, iterate_cols
	
	j fill_b_matrix

iterate_cols:
	li t0, 4		  # размер одного целого числа
	mul t1, a1, a4	  	  # t1 = row_index*col_len
	add t1, t1, a3		  # t1 = t1 + col_index
	mul t1, t1, t0		  # t1 = t1*4
	
	la t2, matrixA		  # загружаем базовый адресс матрицы в t2
	add t2, t2, t1		  # адресс текущего элемента
	lw t4, 0(t2)		  # загружаем элемент матрицы в t4
	
	# печать элемента
	mv   a0, t4	           # Переменная Х
	li   a7, 1                 # Системный вызов write
	ecall                      # Выводим результат
	# символ пробела
	la a0, white_space
	li a7, 4
	ecall
	
	# Добавление элемента к сумме текущей строки
	add a5, a5, t4
    	
    	addi a3, a3, 1		   # col_index++
    	bne a3, a4, iterate_cols   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
	# вывод символа переноса строки
	la a0, new_line
	li a7, 4
	ecall
    	
    	j iterate_rows

update_max_row:
	mv a6, a5		# обновляем сравниваемую макс.сумму
	li t6, 1
	sub a1, a1, t6
	mv t5, a1		# в t5 записываем индекс строки с наиб суммой элементов
	add a1, a1, t6
	
	j iterate_rows

fill_b_matrix:
	li a1, 0		  # счетчик строк
	li a3, 0		  # счетчик столбцов
	
	# Вывод на экран "Filling Matrix B:\n"
	la a0, prompt_filling_matrix_b
	li a7, 4
	ecall

rows_loop:
	li a3, 0		  # сбрасываем счетчик столбцов
	bne a1, a2, cols_loop
	j print_matrix_b

cols_loop:
	# Считаем в t6 индекс смещения относительно максимальной строки  в матрице А
	li t0, 4		  # размер одного целого числа
	mul t1, t5, a4	  	  # t1 = row_index*col_len
	add t1, t1, a3		  # t1 = t1 + col_index
	mul t1, t1, t0		  # t1 = t1*4
	mv t6, t1		  # t6 = t1
	li t1, 0
	li t2, 0
	li t3, 0
	# Считаем в t0 текущий индекс смещения
	li t0, 4		  # размер одного целого числа
	mul t1, a1, a4	  	  # t1 = row_index*col_len
	add t1, t1, a3		  # t1 = t1 + col_index
	mul t1, t1, t0		  # t1 = t1*4
	mv t0, t1		  # t0 = t1
	li t1, 0
	
	# получаем элемент из K-й строки матрицы А
	la t1, matrixA		  # загружаем базовый адресс матрицы  A в t1
	add t1, t1, t6		  # адресс текущего элемента матрицы A в K-й строке
	
	lw t4, 0(t1)         # в t4 Загрузить элемент из исходного массива A в K-й строке
	
	# печать элемента
	mv   a0, t4	           # Переменная Х
	li   a7, 1                 # Системный вызов write
	ecall                      # Выводим результат
	# символ пробела
	la a0, white_space
	li a7, 4
	ecall
	
	# получаем текущие элементы из матрицы A и B
	la t1, matrixA		  # загружаем базовый адресс матрицы  A в t1
	la t2, matrixB		  # загружаем базовый адресс матрицы  B в t2
	add t1, t1, t0		  # адресс текущего элемента матрицы A
	add t2, t2, t0		  # адресс текущего элемента матрицы B
	
	lw t3, 0(t1)         # в t3 Загрузить элемент из исходного массива A
	
	# печать элемента
	mv   a0, t3	           # Переменная Х
	li   a7, 1                 # Системный вызов write
	ecall                      # Выводим результат
	# символ пробела
	la a0, white_space
	li a7, 4
	ecall
	
	## в t3 выполняем деление элемента из матрицы А текущего индекса с элементом матрицы А К-го индекса
	#div t3, t3, t4  	  # t3 = t3 / t4
	
	# 1. Перенос значений из целочисленных регистров в регистры с плавающей запятой
	fmv.w.x f0, t3    # Копируем значение из t3 в f0
	fmv.w.x f1, t4    # Копируем значение из t4 в f1

	# 2. Преобразование целых чисел в числа с плавающей запятой (одинарной точности)
    	fcvt.s.w f0, t3   # Преобразуем целое число в f0 в число с плавающей запятой
    	fcvt.s.w f1, t4   # Преобразуем целое число в f1 в число с плавающей запятой
    	
    	# 3. Деление одного числа с плавающей запятой на другое
    	fdiv.s f2, f0, f1 # Делим число в f0 на число в f1 и сохраняем в f2
	
    	fsw f2, 0(t2)         # Сохранить элемент в целевой массив B
	
	addi a3, a3, 1		   # col_index++
    	bne a3, a4, cols_loop   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
    	# вывод символа переноса строки
	la a0, new_line
	li a7, 4
	ecall
    	
    	j rows_loop

print_matrix_b:
	li a1, 0		  # счетчик строк
	li a3, 0		  # счетчик столбцов
	
	# Вывод в консоль "Matrix B:"
	la a0, prompt_matrix_b
	li a7, 4
	ecall
	
print_rows:
	li a3, 0		  # сбрасываем счетчик столбцов
	bne a1, a2, print_cols
	j end_program

print_cols:
	li t0, 4		  # размер одного целого числа
	mul t1, a1, a4	  	  # t1 = row_index*col_len
	add t1, t1, a3		  # t1 = t1 + col_index
	mul t1, t1, t0		  # t1 = t1*4
	mv t0, t1
	li t1, 0
	
	la t1, matrixB		  # загружаем базовый адресс матрицы  B в t2
	add t1, t1, t0		  # адресс текущего элемента матрицы B
	flw fa0, 0(t1)         # Загрузить элемент из массива B
	
	# печать элемента
	#flw  fa0, f0	           # Переменная Х
	li   a7, 2                 # Системный вызов writeFloat
	ecall                      # Выводим результат
	# символ пробела
	la a0, white_space
	li a7, 4
	ecall
    	
    	addi a3, a3, 1		   # col_index++
    	bne a3, a4, print_cols   # if col_index != col_len
    	
    	addi a1, a1, 1		# row_index++
    	
	# вывод символа переноса строки
	la a0, new_line
	li a7, 4
	ecall
    	
    	j print_rows
	

end_program:
	# Завершаем программу
    	li a7, 10               # Системный вызов exit
    	ecall
	
