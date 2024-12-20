format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable
        struct student
               first_name db 30 dup(0)  ; �������
               name db 30 dup(0)        ; ���
               second_name db 30 dup(0) ; ��������
               age dd 0                 ; �������
        ends
        students student 'Ivanov', 'Ivan', 'Ivanovich', 18
                 student 'Romanov', 'Viktor', 'Petrovich', 19
                 student 'Kuznetsov', 'Gennadiy', 'Nikitich', 20
                 student 'Vasnecov', 'Anatoliy', 'Borisovich', 18
                 student 'Galickiy', 'Ivan', 'Kondratievich', 21
        string_input db '%s', 0    ; ��������� ������ ��� ������ ������
        int_output db '%d', 15, 0  ; ��������� ������ ��� ������ �����
        n dd 5                     ; ���������� ���������
        size_of dd 94              ; ������ ��������� ������ ��������

        write_file_name db 'in',0  ; ��� ����� ��� ������ (in);
        f_mode db 'w',0            ; ����� ������ � ������ (w-������)
        file_d dd 0                ; ���������� �����

        done_msg db 'Done! Data wrote in file "in".', 10, 0 ; ��������� �� �������� ������ � ������� ����



section '.code' code readable writeable executable
start:
        invoke fopen, write_file_name, f_mode
        ; �������� ����� in � ������ ������

        ; ���������� �����
        mov [ds:file_d], eax
        ; ���������� ����������� � ���������� file_d

        mov eax, [ds:n]
        ; ��������� ���-�� ��������� � ������� EAX

        imul [ds:size_of]
        ; �������� ���-�� ��������� �� ������ ������ ��������, ����� ��������� ����� ������ ��� ������

        mov ecx, 1
        ; ������������� ECX � 1 ��� �������� ���-�� �������� (��������) fwrite

        invoke fwrite, students, ecx, eax, [ds:file_d]
        ; ������ ��������� ��������� � ���� (in)

        invoke fclose, [ds:file_d]
        ; �������� �����

        invoke printf, done_msg
        ; ����� ��������� � �������� ������

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