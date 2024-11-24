.data
	filename:   	.string		"C:/Users/alexl/Assembler/AssemlberLabs/1.6/output.txt"    # ПУТЬ ФАЙЛА
	buffer:		.string 	"12 24 55 66 34 68 93 43 23 12 9 5"

.text
.globl _start

# SysCalls https://github.com/TheThirdOne/rars/wiki/Environment-Calls

_start:
open_file:
	# Открыть файл
	li a7, 1024		# системный вызов для открытия файла (sys_open)
	la a0, filename		# Путь до файла
	li a1, 1		# Флаг для записи (O_WRONLY)
	li a2, 0644		# Права доступа
	ecall
	mv s0, a0		# Сохранить дескриптор файла в s0

write_string:
	# Записать в файл
	li a7, 64		# системный вызов для записи (sys_write)
	mv a0, s0		# Дескриптор файла
	la a1, buffer		# Буфер с данными для записи
	li a2, 33		# Кол-во байт для записи
	ecall

close_file:
	# Закрытие файла
	li a7, 57		# Системный вызово для закрытия файла (sys_close)
	mv a0, s0		# Дескриптор файла
	ecall

end_program:
    # Завершение программы
    li      a7, 93           # Системный вызов exit
    li      a0, 0            # Код завершения программы
    ecall
    