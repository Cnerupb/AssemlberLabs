format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable
        struct student
               first_name db 30 dup(0)  ; Фамилия
               name db 30 dup(0)        ; Имя
               second_name db 30 dup(0) ; Отчество
               age dd 0                 ; Возраст
        ends
        students student ?, ?, ?, ?
                 student ?, ?, ?, ?
                 student ?, ?, ?, ?
                 student ?, ?, ?, ?
                 student ?, ?, ?, ?
        string_input db '%s', 0    ; форматная строка для вывода строки
        int_output db '%d', 10, 0  ; Форматная строка для вывода чисел
        struct_output db '%s, %s, %s, %d', 10, 0

        n dd 5                     ; Количество студентов
        size_of dd 94              ; Размер структуры одного студента
        i dd 0                     ; Индекс для итерации по билетам

        read_file_name db 'in',0   ; Имя файла для чтения
        write_file_name db 'out',0 ; Имя файла для записи
        w_mode db 'w',0            ; Режим работы с файлом - запись
        r_mode db 'r',0            ; Режим работы с файлом - чтение
        read_file_d dd 0           ; Дескриптор файла чтения (in)
        write_file_d dd 0          ; Дескрпитор файла записи (out)
        size dd 0                  ; Переменная для хранения размера при итерации

section '.code' code readable writeable executable
start:
        invoke fopen, read_file_name, r_mode


        mov [ds:read_file_d], eax
        ; сохранение дескриптора файла для чтения

        mov eax, [ds:n]
        ; загрузка в EAX кол-ва студентов

        imul [ds:size_of]
        ; Умножение количества билетов на размер одного билета для вычисления общего объема данных

        mov ecx, 1
        ; Устанавливаем количество объектов для чтения в 1

        invoke fread, students, ecx, eax, [ds:read_file_d]
        ; Чтение билетов из файла в структуру students

        invoke fclose, [ds:read_file_d]
        ; Закрытие файла для чтения

        invoke fopen, write_file_name, w_mode
        ; Открытие файла для записи ('out' в режиме 'w')

        mov [ds:write_file_d], eax
        ; Сохранение дескриптора файла для записи

        mov [ds:i], 0
        ; Инициализация переменной индекса i для цикла
        looop2:
                mov eax, [ds:i]
                ; Загрузка текущего индекса в EAX

                imul [ds:size_of]
                ; Умножение индекса на размер структуры студентов для перехода к нужному студенту

                ; расчет поля age
                mov edx, eax
                add edx, students.age
                ; Переход к полю возраста студента

                ; изменение age
                push eax
                mov eax, 1
                ; загрузка значения 1 для увеличения возраста

                add eax, [edx]
                ; увеличение возраста на 1
                mov [edx], eax
                ; сохранение нового возраста
                pop eax


                inc [ds:i]
                ; увеличение индекса i
                mov edx, [ds:i]
                cmp edx, 5
                ; проверка, что было менее 5 студентов
                jne looop2

        ; Обновили возраст. Выведем изменения на экран
        ; расчет количества байт для записи в файл
        mov eax, [ds:n]
        ; Загрузка количества билетов в регистр EAX

        imul [ds:size_of]
        ; Вычисление общего размера данных для записи

        mov ecx, 1
        ; Количество объектов для записи

        mov [ds:i], 0
        ; Инициализация индекса i для второго цикла

        looop:
                ; расчет смещения к началу структуры
                mov eax, [ds:i]
                imul [ds:size_of]
                mov [ds:size], eax

                ; расчет полей
                mov ebx, [ds:size]
                add ebx, students.first_name


                mov ecx, [ds:size]
                add ecx, students.name


                add eax, students.second_name


                mov edx, [ds:size]
                add edx, students.age


                invoke printf, struct_output, ebx, ecx, eax, [edx]

                inc [ds:i]
                mov edx, [ds:i]
                cmp edx, 5
                jne looop


        ; запись в файл и закрытие
        invoke fwrite, students, ecx, [ds:size], [ds:write_file_d]
        invoke fclose, [ds:write_file_d]


        invoke getch
        invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf, 'scanf', fopen, 'fopen', fwrite, 'fwrite', fclose, 'fclose', fread, 'fread'