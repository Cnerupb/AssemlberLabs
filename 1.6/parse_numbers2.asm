.data
	buffer: 	.space 100			# Буфер для чтения данных
	filename: 	.string "output.txt"		# Путь до файла
	white_space:	.string " "			# Символ пробела
	newline:	.string " Newline\n"		# Символ новой строки
	numbers:	.word 48			# 12 чисел по 4 байта (48 байт всего)
	

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
	# Вывод символа в консоль
	li a7, 1
	mv a0, t6
	ecall
	# Пробел
	li a7, 11
	li a0, ' '
	ecall
	
	sw t6, 0(t1)			# сохраняем число в массив numbers
	li t6, 0			# обнуляем число
	
	addi t0, t0, 1
	addi t1, t1, 4
	j parse_loop

end_parse_loop:
	# Вывод символа в консоль
	li a7, 1
	mv a0, t6
	ecall

	sw t6, 0(t1)

	la t0, numbers			# Загружаем адресс массива
	li t1, 12			# Кол-во чисел для вывода

print_numbers_loop:
	lw t2, 0(t0)
	
	bnez t1, end_print_numbers_loop
	
	# Вывод числа в консоль
	li a7, 1
	mv a0, t2
	ecall
	# Вывод символа пробела
	li a7, 11
	li a0, ' '
	ecall

next_number_to_print:
	addi t0, t0, 4
	li a5, 1
	sub t1, t1, a5
	j print_numbers_loop

end_print_numbers_loop:
end_program:
	li a7, 93			# Системный вызов для выхода (sys_exit)
	li a0, 0			# Код возврата
	ecall