.global _start

.data
  buffer: .space 1024  // Буфер для ввода строки
  shortest_word: .space 1024 // Буфер для самого короткого слова
  newline: .asciz "\n"

.text
_start:
  // Читаем строку с консоли
  mov x0, #0          // stdin
  adr x1, buffer      // адрес буфера
  mov x2, #1023       // максимальная длина строки
  mov x8, #63         // номер системного вызова read
  svc #0

  // Устанавливаем указатели на начало и конец строки
  adr x9, buffer      // указатель на начало строки
  mov x10, x0        // x0 содержит число считанных байт

  // Добавляем нулевой байт в конец строки
  add x10, x9, x10    // Указатель на конец строки
  strb wzr, [x10]     // 0-байт в конце


  // Инициализируем длину самого короткого слова максимальным значением
  mov x11, #1024


  // Находим самое короткое слово
find_shortest:
  // Пропускаем начальные пробелы
  skip_spaces:
    ldrb w12, [x9]
    cmp w12, #' '
    beq skip_spaces
    bne word_start

  word_start:
    // Находим конец слова
    adr x13, shortest_word //адрес буфера самого короткого слова
    mov x14, x9          // указатель на начало слова
    find_word_end:
      ldrb w12, [x9]
      cmp w12, #' '
      beq word_end
      cmp w12, #0
      beq word_end
      add x9, x9, #1
      b find_word_end

    word_end:
    sub x15, x9, x14    // длина текущего слова
    cmp x15, x11         // сравнение с длиной самого короткого слова
    bge next_word       // если текущее слово длиннее - пропускаем
    mov x11, x15         // обновляем длину самого короткого слова
    // копируем слово
    mov x16, x14
    mov x17, x13
    copy_word:
      ldrb w12, [x16]
      strb w12, [x17]
      cmp w12, #0
      beq copy_done
      add x16, x16, #1
      add x17, x17, #1
      b copy_word
    copy_done:

  next_word:
    // Пропускаем пробелы между словами
    skip_spaces2:
      ldrb w12, [x9]
      cmp w12, #' '
      bne find_shortest
      add x9, x9, #1
      b skip_spaces2

  // Выводим самое короткое слово
  adr x0, shortest_word
  mov x1, x11
  mov x8, #64          // номер системного вызова write
  svc #0


  // Выводим символ новой строки
  adr x0, newline
  mov x1, #1
  mov x8, #64
  svc #0

  // Завершаем программу
  mov x0, #0
  mov x8, #93
  svc #0
