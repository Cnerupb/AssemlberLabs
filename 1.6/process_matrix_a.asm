.data
	filename: 	.string "output.txt"		# Путь до файла
	white_space:	.string " "			# Символ пробела
	newline:	.string "\n"			# Символ новой строки
	prompt_buff:	.string "buffer: "
	prompt_nums:	.string "numbers: "
	prompt_mb:	.string "Matrix B: "
	buffer: 	.space 48			# Буфер для чтения данных
	numbers:	.word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1	# 12 чисел по 4 байта (48 байт всего)
	matrixB:	.word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1	# 12 чисел по 4 байта
	

.text
.globl _start

_start:
open_file:
	# Открыть файл для чтения
	li a7, 1024			# Системный вызов для открытия файла (sys_open)
	la a0, filename			# Имя файла
	li a1, 0			# Флаг для чтения (O_RDONLY)
	li a2, 0			# Права доступа (не используются при чтении)
	ecall
	mv s0, a0			# Сохранить дескриптор файла в s0

read_string:
	# Прочитать данные из файла
	li a7, 63			# Системный вызов для чтения (sys_read)
	mv a0, s0			# Дескриптор файла
	la a1, buffer			# Буфер для чтения данных
	li a2, 200			# Максимальное кол-во байт для чтения
	ecall
	mv s1, a0			# Сохранить кол-во прочитанных байт в s1

close_file:
	# Закрыть файл
	li a7, 57			# Системный вызов для закрытия файла (sys_close)
	mv a0, s0			# Дескриптор файла
	ecall

print_string:
	li a7, 4
	la a0, prompt_buff
	ecall

	# Вывести считанную строку в консоль
	li a7, 64			# Системный вызов sys_write
	li a0, 1			# Дескриптор файла для стандартного вывода (stdout)
	la a1, buffer			# Буфер с данными
	mv a2, s1			# Кол-во байт для записи
	ecall
	
	# Вывод символа переноса строки
	li a7, 4
	la a0, newline
	ecall

parse_buffer:
	# Конвертация символов в числа
	la t0, buffer			# Адрес буфера
	la t1, numbers			# Адрес массива чисел
	li t6, 0			# Текущее число

parse_loop:
	# Цикл конвертации
	lb t2, 0(t0)			# Загрузить текущий символ
	
	beqz t2, end_parse_loop	# Если конец строки, то завершаем парсинг и записываем последнее число
	
	li t3, ' '			# Загрузить символ пробела
	beq t2, t3, next_number		# Если текущий символ - пробел, то переходим к следующему числу
	
	# Конвертация и добавление цифры в конец числа
	li a5, '0'
	sub t2, t2, a5			# Цифра = число символа - число символа ноль (31 - 30 = 1, 32 - 30 = 2, ...)
	li a5, 10
	mul t6, t6, a5			# Умножаем число на 10
	add t6, t6, t2			# Добавляем цифру
	
	# Перейти к следующему символу
	addi t0, t0, 1			
	j parse_loop

next_number:
	sw t6, 0(t1)			# сохраняем число в массив numbers
	li t6, 0			# обнуляем число
	
	addi t0, t0, 1
	addi t1, t1, 4
	j parse_loop

end_parse_loop:
	sw t6, 0(t1)
	
	li a7, 4
	la a0, prompt_nums
	ecall
	
	la t0, numbers			# Загружаем адресс массива
	li t1, 0			# Под число
	li t2, 0			# счетчик длины
	li t3, 12			# Длина массива

print_numbers_loop:
	# выводим массив numbers типа .word
	beq t2, t3, end_print_numbers_loop
	
	# Вывод числа в консоль
	li a7, 1
	lw t1, 0(t0)
	mv a0, t1
	ecall
	# Вывод символа пробела
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	
	addi t2, t2, 1
	j print_numbers_loop

end_print_numbers_loop:
	# новая строка
	li a7, 4
	la a0, newline
	ecall

	la t0, numbers
	la t1, matrixB
	li t2, 0		# под загружаемый элемент
	li t3, 0
	li t4, 12

loop_1:
	# копируем матрицу numbers в матрицу B
	beq t3, t4, end_loop_1
	
	lw t2, 0(t0)			# загружаем число из массива
	sw t2, 0(t1)			# сохраняем в матрицу B
	
	addi t0, t0, 4
	addi t1, t1, 4
	
	addi t3, t3, 1
	j loop_1
	
end_loop_1:
	# вывод в консоль "Matrix B:"
	li a7, 4
	la a0, prompt_mb
	ecall

	la t0, matrixB
	li t1, 0			# под загружаемый элемент
	li t2, 0			# счетчик длины
	li t3, 12			# длина матрицы

loop_2:
	# вывод матрицы B
	beq t2, t3, end_loop_2
	
	# Вывод числа в консоль
	li a7, 1
	lw t1, 0(t0)
	mv a0, t1
	ecall
	# Вывод символа пробела
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	
	addi t2, t2, 1
	j loop_2

end_loop_2:
	j end_program
	la t0, matrixB
	li t1, 12
	

print_mb_loop_1:
	beqz t1, end_print_mb_loop_1
	
	# Печать символа
	li a7, 1
	lw t2, 0(t0)
	mv a0, t2
	ecall
	# Пробел
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	li a5, 1
	sub t1, t1, a5
	j print_mb_loop_1
	
end_print_mb_loop_1:
	la t0, numbers
	la t1, matrixB
	li t2, 0			# индекс строки
	li t3, 0			# индекс столбца
	# в s0 индекс макс строки
	li s2, 3			# кол-во строк
	li s3, 4			# кол-во столбцов

row_loop_3:
	beq t2, s2, end_loop_3
	
	li t3, 0
	j col_loop_3

col_loop_3:
	beq t3, s3, next_row_3
	
	# высчитываем индекс элемента K-й строки
	li t4, 4
	mv t5, s0			# t5 = max_row_index
	mul t5, t5, t4			# 4*max_row_index
	add t5, t5, t3			# 4*max_row_index + col_index
	mul t5, t5, t4			# (4*i + j)*4
	
	la t4, numbers
	add t4, t4, t5
	
	lw t4, 0(t4)			# загружаем в t4 элемент K-й строки
	lw t5, 0(t0)			# в t5 загружаем текущий элемент в матрице А
	
	div t5, t5, t4			# делим элемент из матрицы на элемент из матрицы из K-й строки
	
	sw t5, 0(t1)			# записываем элемент в матрицу B
	
	addi t0, t0, 4
	addi t1, t1, 4
	addi t3, t3, 1
	j col_loop_3
	

next_row_3:
	addi t0, t0, 4			# Переходим к следующему элементу матрицы A
	addi t1, t1, 4			# Переходим к следующему элементу матрицы B
	addi t2, t2, 1
	j row_loop_3

end_loop_3:
	# Новая строка
	li a7, 4
	la a0, newline
	ecall

	la t0, matrixB
	li t1, 0			# под загружаемый элемент
	li t2, 0			# индекс строки
	li t3, 0 			# индекс столбца

row_loop_4:
	beq t2, s2, end_loop_4
	
	li t3, 0
	j col_loop_4

col_loop_4:
	beq t3, s3, next_row_4
	
	# Печать элемента
	lw t6, 0(t0)
	li a7, 1
	mv a0, t6
	ecall
	# Пробел
	li a7, 11
	li a0, ' '
	ecall
	
	addi t0, t0, 4
	addi t3, t3, 1
	j col_loop_4

next_row_4:
	# новая строка
	li a7, 4
	la a0, newline
	ecall

	addi t0, t0, 4
	addi t2, t2, 1
	j row_loop_4

end_loop_4:
end_program:
	li a7, 93			# Системный вызов для выхода (sys_exit)
	li a0, 0			# Код возврата
	ecall
