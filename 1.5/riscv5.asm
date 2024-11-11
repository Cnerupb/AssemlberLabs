.data
	prompt_a:  .string "Enter A: "
    	prompt_x:  .string "Enter X: "
   	result_1:  .string "Y for X = "
    	result_2:  .string " is: "
    	new_line:  .string "\n"

.text
.globl _start
_start:
	# Обработка А
    	la   a0, prompt_a          # Загружаем строку запроса в a0
    	li   a7, 4                 # Системный вызов write
    	ecall                      # Вызов ядра для вывода
    	li   a7, 5                 # Системный вызов read integer
    	ecall                      # Чтение целого числа A
    	mv   s0, a0                # Сохраняем A в s0
    	
    	# Получаем значение X
	la   a0, prompt_x          # Загружаем строку запроса в a0
	li   a7, 4                 # Системный вызов write
    	ecall                      # Вызов ядра для вывода
    	li   a7, 5                 # Системный вызов read integer
    	ecall                      # Чтение целого числа X
   	mv   s1, a0                # Сохраняем начальный X в s1
   	
   	# Х в s1 будет модифицироваться, поэтому сохраняем исходник в s2
   	mv   s2, a0
   	
loop:
calc_y1:
	# y1 = 4 - X, если |X| < 3; X - A, в остальных случаях
	mv t0, s1                # Копируем X в t0
	blt t0, zero, negate_x   # Если X < 0, то X = |X| в регистре t0
	
	li t1, 3
	blt t0, t1, calc_y1_fc 	 # Если |X| < 3, то считаем y1 по первому случаю
	
	j calc_y1_sc		 # Иначе по второму

negate_x:
    	neg  t0, t0                # Делаем X положительным
    	li t1, 3
	blt t0, t1, calc_y1_fc 	 # Если |X| < 3, то считаем y1 по первому случаю
	
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
    	# y2 = 2, если X - чётное; A + 2 - в остальных случаях
    	mv t0, s1	# Копируем X в t0
    	li t1, 2	# В t3 помещаем 2
    	li t4, 0
    	rem t4, t0, t1	# В t4 остаток от деления X на 2
    	beq t4, zero, calc_y2_fc	# Если X - чётное, считаем по первому случаю
	
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

    # Вывод результата ===============================================
    la   a0, result_1          # Загружаем половину строки результата
    li   a7, 4                 # Системный вызов write
    ecall                      # Выводим результат


    mv   a0, s1	               # Переменная Х
    li   a7, 1                 # Системный вызов write
    ecall                      # Выводим результат
    
    la   a0, result_2          # Загружаем is:
    li   a7, 4                 # Системный вызов write
    ecall                      # Выводим результат
    
    
    mv   a0, t4                # Второй аргумент - Y
    li   a7, 1                 # Системный вызов write
    ecall                      # Выводим результат
    
    la   a0, new_line          # Загружаем new_line
    li   a7, 4                 # Системный вызов write
    ecall                      # Выводим результат
    # ================ ===============================================

    # Увеличиваем X на 1
    li   t0, 1                 # t5 = 1
    add  s1, s1, t0            # Увеличиваем X на 1

    # Проверяем, достигли ли X + 9
    li   t5, 10                 # t5 = 9
    add  t6, s2, t5            # t6 = X + 9
    blt  s1, t6, loop          # Повторяем, если X <= X + 9

    # Завершение программы
    li   a7, 93                # Системный вызов для завершения
    ecall                      # Завершаем программу
	