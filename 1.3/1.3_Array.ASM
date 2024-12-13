format PE console

entry start

include 'win32ax.inc'

;=======================================================
section '.data' data readable writeable
;=======================================================
        matrix db 0, 0, 1, 0, 97 ; �������, �������� � ����.
               db 3, 4, 2, 4, 0 ; ������ ������� 4x4 (4 ������, 4 �������).
               db 5, 8, 6, 4, 5
               db -1, -2, -1, 0, -9
               db 0, 0, 0, 0, 0

        b_vec db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ; ������(������) b

        matrix_rows equ 5      ; ���������� ����� �������.
        matrix_cols equ 5      ; ���������� �������� �������.
        m dd 5                 ; ���������� ��� �������� �� ������� (m = 4).
        n dd 5                 ; ���������� ��� �������� �� �������� (n = 4).
        max_sum dd 0
        min_sum dd 9999999
        max_i dd 0             ; index of row with max sum
        min_i dd 0             ;

        output_debug db 'done!', 10, 0
        output_digit db '%d', 10, 0
        output_max_sum db 'Max summa: %d', 10, 0
        output_max_i db 'Max summa index: %d', 10, 0
        output_min_sum db 'Min summa: %d', 10, 0
        output_min_i db 'Min summa index: %d', 10, 0
        fmtInt db '%d ', 0
        newLine db '\n', 0

        output_b_1 db 'Result vector: [%d, ', 0
        output_b_2 db '%d, ', 0
        output_b_3 db '%d]', 10, 0

;=======================================================
section '.text' code readable executable
;=======================================================
start:

;==================== ����� ����� =====================

initial_setup:
        mov esi, 0             ; ������������� �������� ����� (i = 0).
        mov edi, 0             ; ������������� �������� �������� (j = 0).
        mov edx, 0             ; ������ ����� ��������� ������

; ��������� ������������, ��� � �����, ������� � ���� �������� �������. ������� ����� ������������ 1 ������ �� ���������
outer_loop:
        cmp esi, [m] ; if i >= m
        jge end_outer_loop

        mov edi, 0
        mov edx, 0
        jmp inner_loop


end_outer_loop:
         mov edi, 0
         mov esi, 0
         jmp fill_max_row

inner_loop:
        ; if j >= n
        cmp edi, [n]
        jge end_inner_loop

        mov ebx, 0
        mov eax, 0
        mov eax, esi
        imul eax, [m]
        add eax, edi
        movzx ebx, byte [matrix + eax] ; ���������� � ebx ������� matrix[i][j]
        add edx, ebx ; ����������� ����� ��������� ������� ������ � edx


        inc edi ; j ++
        jmp inner_loop

end_inner_loop: ; ����������� ���������� ����
        mov edi, 0 ; j = 0
        inc esi ; i++

        jmp update_sum  ; ��������� ����/��� �����. ��� �� ������������� �� ������� ����

update_sum:
        ; ��������� ���/���� ����� ����� �������
        ; ���������� ������� ���/���� ���� ����� �������
        cmp edx, [max_sum]
        jg update_max_sum
        cmp edx, [min_sum]
        jl update_min_sum
        jmp outer_loop ; ������������ � �������� ����� �� �������

update_max_sum:
        mov [max_sum], edx
        dec esi
        mov [max_i], esi
        inc esi
        jmp update_sum

update_min_sum:
        mov [min_sum], edx
        dec esi
        mov [min_i], esi
        inc esi
        jmp update_sum

fill_max_row:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0

        mov ebp, [m] ; ������� ����� ������� b
        add ebp, [n]
        mov esi, matrix ; ��������� �� �������
        mov ebx, [max_i] ; ��������� �� ������� � ���� ������
        imul ebx, [n]
        add esi, ebx
        mov edi, b_vec ; ��������� �� ������ b

        jmp fill_max_row_loop

fill_max_row_loop:
        cmp ecx, ebp
        jge end_fill_max_row_loop

        mov al, [esi]
        mov [edi], al

        inc esi
        add edi, 2
        add ecx, 2
        jmp fill_max_row_loop

end_fill_max_row_loop:
        jmp fill_min_row

fill_min_row:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0

        mov ebp, [m] ; ������� ����� ������� b
        add ebp, [n]

        mov esi, matrix ; ��������� �� �������
        mov ebx, [min_i] ; ��������� �� ������� � ���� ������
        imul ebx, [n]
        add esi, ebx

        mov edi, b_vec ; ��������� �� ������ b
        inc edi

        jmp fill_min_row_loop

fill_min_row_loop:
        cmp ecx, ebp
        jge end_fill_min_row_loop

        mov al, [esi]
        mov [edi], al

        inc esi
        add edi, 2
        add ecx, 2
        jmp fill_min_row_loop

end_fill_min_row_loop:
        jmp print_result

print_result:
        invoke printf, output_debug
        invoke printf, output_max_sum, [max_sum]
        invoke printf, output_max_i, [max_i]
        invoke printf, output_min_sum, [min_sum]
        invoke printf, output_min_i, [min_i]
        jmp print_vector

print_vector:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        add ecx, 0
        mov ebp, [n]
        add ebp, [n]
        dec ebp
        mov esi, 0
        mov esi, 0
        mov edi, 0
        mov edi, 0
        jmp print_first

print_first:
        movzx eax, byte [b_vec + esi]
        invoke printf, output_b_1, eax
        inc esi
        jmp print_loop

print_loop:
        cmp esi, ebp
        jge end_print_loop

        movzx eax, byte [b_vec + esi]
        invoke printf, output_b_2, eax
        inc esi

        jmp print_loop

end_print_loop:
        movzx eax, byte [b_vec + esi]
        invoke printf, output_b_3, eax
        invoke getch                             ; �������� ������� �������.
        invoke ExitProcess, 0                    ; ���������� ���������.

;=======================================================
section '.idata' import readable writable
;=======================================================
library kernel32, 'KERNEL32.DLL',\
user32, 'USER32.DLL',\
msvcrt, 'msvcrt.dll'

include 'api\kernel32.inc'
include 'api\user32.inc'
import msvcrt, printf, 'printf', \
scanf, 'scanf', getch, '_getch'