format PE console 4.0

entry start

include 'win32a.inc'

; Определение размера буфера для ввода строки
define  string_buf  512

;=======================================================
section '.data' data readable writable
;=======================================================

        ; char_print         db   '%c', 0                     ; Формат для вывода символа
        msg_string         db   'Enter string: ', 10, 0     ; Сообщение для пользователя при запросе строки
        output_words_len   db   'Words len: %d', 10, 0
        output_string_len  db   'String len: %d', 10, 0
        output_string_wc   db   'Word count: %d', 10, 0
        output_string_full_len db 'String len except end symbol: %d', 10, 0
        output_float       db   'Result is %5.5f', 10, 0
        input_string       db   string_buf dup(0)           ; Буфер для хранения введенной строки
        len_string         dd   0                           ; Длина строки
        len_string_woes    dd   0
        len_string_ees     dd   0
        len_words          dd   0
        word_count         dd   0
        average_word_len   dq   0

        NULL = 0

;=======================================================
section '.idata' import data readable
;=======================================================
 
        library msvcrt,'MSVCRT.DLL',\
                kernel32,'KERNEL32.DLL'
 
        import kernel32,\
            ExitProcess, 'ExitProcess',\
               sleep,'Sleep'
 
        import msvcrt,\
               gets,'gets',\
               printf,'printf', \
               getch, '_getch'

;=======================================================
section '.code' code readable executable
;=======================================================

; Процедура подсчёта средней длины
count_words:
    cld ; DL = 0                ; Очищаем флаг направления для корректного движения по строке
    mov   ax, ds                ; Сохраняем сегмент данных в ES
    mov   es, ax
    lea   edi, [input_string]   ; Загружаем адрес строки в регистр EDI
    mov   al, 0                 ; Устанавливаем значение AL в 0 для поиска конца строки (null-символа)
    mov   ecx, string_buf       ; Устанавливаем размер буфера ECX для поиска конца строки
    repnz scasb                 ; Ищем null-символ в строке

    mov   eax, string_buf       ; Рассчитываем длину строки
    sub   eax, ecx
    mov   [len_string], eax     ; Сохраняем длину строки
    mov   ecx, eax              ; Загружаем длину строки в ECX для дальнейшей работы
    mov   ebx, ecx              ; Сохраняем начальное значение ECX в EBX (нужно для расчета длины слов)
    ; mov   edx, 0                ; Инициализируем максимальную длину слова в EDX (пока 0)
    mov   edx, 0                ; В EDX будем хранить сумму длин слов
    lea   edi, [input_string]   ; Снова загружаем адрес строки в EDI для начала поиска слов

    ; Цикл поиска слов
    find_word:
      mov   al,  32             ; Устанавливаем AL равным пробелу (код символа 32)
      ; repz scasb
      repnz scasb               ; Ищем следующий пробел или конец строки
      mov   eax, ebx            ; Рассчитываем длину текущего слова
      sub   eax, ecx
      dec   eax                 ; Учитываем пробел
      add edx, eax              ; Записываем длинну слова в EDX
      end_count:
        mov   ebx, ecx            ; Сохраняем текущее значение ECX в EBX для следующей итерации
      
        cmp   ecx, 0              ; Если конец строки не достигнут, продолжаем цикл
        jne   find_word
    mov [len_words], edx       ; записываем суммарную длину слов в переменную
    ret

print_result:
    invoke printf, output_words_len, [len_words]
    mov ecx, [len_string]
    dec ecx
    mov [len_string_woes], ecx
    invoke printf, output_string_len, [len_string_woes]
    inc ecx
    invoke printf, output_string_full_len, [len_string]
    dec ecx

    ; Средняя_длина_слова = Суммарная_длина_всех_слов / (Общая_длина_строки - Суммарная_длина_всех_слов + 1)
    mov eax, [len_string_woes]
    mov ebx, [len_words]
    sub eax, ebx
    inc eax
    mov [word_count], eax
    invoke printf, output_string_wc, [word_count]

    ; Считаем среднюю длину слова
    finit
    fild dword [ds:word_count]
    fild dword [ds:len_words]
    fdiv st0, st1
    fstp qword [ds:average_word_len]

    ; Выводим среднюю длину слова
    invoke printf, output_float, dword [ds:average_word_len], dword [ds:average_word_len+4]

    invoke getch                    ; Ожидание нажатия клавиши
    invoke ExitProcess, 0           ; Завершаем программу

    
; точка входа    
start:
    
    cinvoke printf, msg_string      ; Выводим сообщение для ввода строки
    cinvoke gets, input_string      ; Получаем ввод от пользователя
    call count_words                ; Вызываем процедуру подсчёта длины слова
    call print_result           ; Вызываем процедуру вывода самого длинного слова
    invoke getch                    ; Ожидание нажатия клавиши
    invoke ExitProcess, 0           ; Завершаем программу