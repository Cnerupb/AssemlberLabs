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
        students student 'Ivanov', 'Ivan', 'Ivanovich', 18
                 student 'Romanov', 'Viktor', 'Petrovich', 19
                 student 'Kuznetsov', 'Gennadiy', 'Nikitich', 20
                 student 'Vasnecov', 'Anatoliy', 'Borisovich', 18
                 student 'Galickiy', 'Ivan', 'Kondratievich', 21
        string_input db '%s', 0    ; форматная строка для вывода строки
        int_output db '%d', 15, 0  ; Форматная строка для вывода чисел
        n dd 5                     ; Количество студентов
        size_of dd 94              ; Размер структуры одного студента

        write_file_name db 'in',0  ; Имя файля для записи (in);
        f_mode db 'w',0            ; Режим работы с файлом (w-запись)
        file_d dd 0                ; Дескриптор файла

        done_msg db 'Done! Data wrote in file "in".', 10, 0 ; Сообщение об успешной записи в целевой файл



section '.code' code readable writeable executable
start:
        invoke fopen, write_file_name, f_mode
        ; открытие файла in в режиме записи

        ; дескриптор файла
        mov [ds:file_d], eax
        ; сохранение дексриптора в переменной file_d

        mov eax, [ds:n]
        ; загружаем кол-во студентов в регистр EAX

        imul [ds:size_of]
        ; умножаем кол-во студентов на размер одного студента, чтобы высчитать общий размер для записи

        mov ecx, 1
        ; устанавливаем ECX в 1 для передачи кол-ва объектов (структур) fwrite

        invoke fwrite, students, ecx, eax, [ds:file_d]
        ; запись структуры студентов в файл (in)

        invoke fclose, [ds:file_d]
        ; закрытие файла

        invoke printf, done_msg
        ; вывод сообщения о успешной записи

        invoke getch
        invoke ExitProcess, 0




section '.idata' data import readable
  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf, 'scanf', fopen, 'fopen', fwrite, 'fwrite', fclose, 'fclose'