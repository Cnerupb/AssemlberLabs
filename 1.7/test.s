.global _start

.data
  buffer: .space 1024  // Буфер для строки (1024 байта)
  newline: .asciz "\n"

.text
_start:
  // read(0, buffer, 1023)
  mov x0, #0       // stdin
  adr x1, buffer   // address of buffer
  mov x2, #1023    // max bytes to read
  mov x8, #63      // sys_read
  svc #0           // system call

  // вывод кол-ва считанных байт
  mov x1, x0
  mov x0, #1
  mov x2, #5
  mov x8, #64
  svc #0

print_string:
  // write(1, buffer, strlen(buffer))
  mov x0, #1       // stdout
  adr x1, buffer   // address of buffer
  // strlen(buffer) - нужно найти длину строки
  mov x3, xzr      // x3 = 0 (счетчик длины)
strlen_loop:    // высчитываем длину слова для вывода
  ldrb w4, [x1, x3] // Загружаем байт из буфера
  cbz w4, strlen_end // Если байт равен нулю (конец строки), выходим
  add x3, x3, #1   // Увеличиваем счетчик
  b strlen_loop    // Переходим на начало цикла

strlen_end:
  mov x2, x3       // x2 = длина строки
  mov x8, #64      // sys_write
  svc #0           // system call

print_new_line:
  // write(1, newline, 1) - выводим новую строку
  mov x0, #1       // stdout
  adr x1, newline // address of newline
  mov x2, #1      // length of newline
  mov x8, #64      // sys_write
  svc #0           // system call

end_program:
  // exit(0)
  mov x0, #0       // exit code 0
  mov x8, #93      // sys_exit
  svc #0           // system call
