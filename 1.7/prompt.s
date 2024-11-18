.data
    input_prompt: .asciz "Введите строку: "
    output_prompt: .asciz "Самое короткое слово: "
    output_1: .asciz "loop 1"
    output_empty_str: .asciz "Пустая строка\n"
    newline: .asciz "\n"
    input_buffer: .skip 128
    shortest_word: .skip 128

.text
.global _start
_start:
print_input_prompt:
    ldr x0, =input_prompt
    mov x1, #30

    // Вывод строки
    ldr x0, =input_prompt
    bl strlen
    mov x2, x0
    ldr x1, =input_prompt
    mov x0, #1
    mov x8, #64
    svc #0

get_input:
    mov x0, #0       // stdin
    ldr x1, =input_buffer   // address of buffer
    mov x2, #128    // max bytes to read
    mov x8, #63      // sys_read
    svc #0           // system call

print_output_input:
    mov x0, x1
    mov x5, x0
    bl strlen
    mov x2, x0
    mov x0, #1
    mov x1, x5
    mov x8, #64
    svc #0

start_find:
    cmp x2, #1
    beq print_empty_result

    ldr x0, =input_buffer
    bl strlen       // вызов функции подсчёта длины
    ldr x1, =input_buffer   // указатель на первый символ строки
    mov x2, x0      // длина введённой строки, вычисленная с помощью strlen
    mov x3, #0      // индекс символа в строке
    mov x4, #0      // индекс предшествующего пробела
    mov x5, #128    // длина самого короткого слова
    mov x6, #0      // индекс конца пробела самого короткого слова в строке

loop_1:
    ldrb w6, [x1, x3]   // загружаем 1 байт
    cmp w6, #' '    // проверка на нахождение пробела
    beq update_word

    cmp w6, #0      // проверка на конец строки
    beq end_loop_1

    b update_loop_1

update_loop_1:
    add x3, x3, #1  // следующий символ
    b loop_1

update_word:
    sub x7, x3, x4  // длина слова = индекс текущего пробела - индекс предшествующего - 1
    cmp x7, x5      // сравнение с длинной короткого слова
    bge update_word_0

    cmp x4, #0      // если это первое встреченное нами слово, записываем его длину в x5
    beq update_word_1

    b update_word_2 // если слово где-то в середине

    update_word_0:
        mov x4, x3      // обновить индекс предшествующего пробела на текущий
        b update_loop_1
    update_word_1:
        add x7, x7, #1  // досчитать длину слова
        mov x5, x7      // обновить текущуюю длину короткого слова
        mov x4, x3      // обновить индекс предшествующего пробела на текущий
        mov x6, x3      // запомнить индекс оканчивающиегося пробела текущего слова
        b update_loop_1
    update_word_2:
        sub x7, x7, #1
        mov x5, x7
        mov x4, x3
        mov x6, x3
        b update_loop_1

end_loop_1:
    sub x7, x3, x4  // длина слова = индекс текущего пробела - индекс предшествующего - 1
    cmp x7, x5      // сравнение с длинной короткого слова
    bge fill_output // если >=, то переходим к заполнению результирующей строки

    cmp x4, #0      // если это первое встреченное нами слово, записываем его длину в x2
    beq update_word_1_1
    b update_word_2_1

    update_word_1_1:
        add x7, x7, #1  // досчитать длину слова
        mov x5, x7      // обновить текущуюю длину короткого слова
        mov x4, x3      // обновить индекс предшествующего пробела на текущий
        mov x6, x3      // запомнить индекс оканчивающиегося пробела текущего слова
        b fill_output
    update_word_2_1:
        sub x7, x7, #1
        mov x5, x7
        mov x4, x3
        mov x6, x3
        b fill_output


fill_output:
    ldr x1, =input_buffer   // указатель на начало введённой строки
    mov x3, x6              // в x3 помещаем индекс конца самого короткого слова
    sub x3, x3, x5          // считаем в x3 индекс начала самого короткого слова
    add x1, x1, x3          // смещаем указатель на этот индекс начала

    mov x3, #0              // сбрасываем счетчик
    ldr x8, =shortest_word  // указатель на начало введённой строки
    fill_loop:
        ldrb w6, [x1, x3]   // загружаем по индексу из исходной строки байт
        cmp w6, #0          // если он конец строки, завершаем цикл
        beq end_fill_loop

        strb w6, [x8], #1   // иначе загружаем его в результирующую строку
        add x3, x3, #1      // увеличиваем счетчик на 1
        b fill_loop

end_fill_loop:
    strb wzr, [x8], #1  // добавляем в конце 0 чтобы обозначит конец строки

print_result:
    // вывод результирующей строки
    mov x0, #1
    mov x1, x8
    mov x2, x5
    mov x8, #64
    svc #0
    b end_program

print_empty_result:
    ldr x0, =output_empty_str
    bl strlen
    mov x2, x0
    ldr x1, =output_empty_str
    mov x0, #1
    mov x8, #64
    svc #0
    b end_program

end_program:
    // Завершаем программу
    mov x0, #0              // return 0 status
    mov x8, #93             // exit system call
    svc #0

strlen:
    // int strlen( const char * x0 /* s */ )

    // Set a reasonable maximum and branch to strnlen_s
    mov     x1, #1000
    b       strnlen_s
strnlen_s:
    // int strnlen_s( const char * x0 /* s */, int x1 /* max_len */ )

    // Register usage:
    //  x0 - Input pointer to string
    //  x1 - Max length we want to search
    // Intermediates:
    //  x2 - Running count of non-null bytes in string
    //  x3 - Place for testing if byte in string is null

    // We're not calling any subroutines.  No need for any stack work

    // Initialise our count
    mov     x2, #0

.L_strnlen_s_main_loop:
    // Load byte pointed to by x0 ready and test if it is zero
    // Branch to exit if it is 0
    ldrb    w3, [x0], #+1
    cmp     x3, #0
    b.eq    .L_strnlen_s_exit

    // Record we have another byte
    add     x2, x2, 1

    // Decrement our maximum string length counter
    // Branch to exit if it is zero
    subs    x1, x1, 1
    b.eq    .L_strnlen_s_exit

    // Repeat
    b       .L_strnlen_s_main_loop

.L_strnlen_s_exit:
    // Return the discovered length in x0
    mov     x0, x2

    // Return
    ret
