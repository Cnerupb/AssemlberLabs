.global _start          // устанавливаем стартовый адрес программы
 
_start: mov X0, #1          // 1 = StdOut - поток вывода
 ldr X1, =hello             // строка для вывода на экран
 mov X2, #19                // длина строки
 mov X8, #64                // устанавливаем функцию Linux
 svc 0                      // вызываем функцию Linux для вывода строки
 
 mov X0, #0                 // Устанавливаем 0 как код возврата
 mov X8, #93                // код 93 представляет завершение программы
 svc 0                      // вызываем функцию Linux для выхода из программы
 
.data
hello: .ascii "Hello METANIT.COM!\n"    // данные для вывода
