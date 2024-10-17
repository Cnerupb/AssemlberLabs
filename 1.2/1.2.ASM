format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        input_x db 'Enter X: ', 0
        input_a db 'Enter A: ', 0
        input_float db '%lf', 0

        output_x db 'x = %5.3f', 10, 0
        output_a db 'a = %5.3f', 10, 0
        output_y1 db 'y1 = %5.3f', 10, 0
        output_y2 db 'y2 = %5.3f', 10, 0
        output_y db 'y = %5.3f', 10, 0
        output_newline db '', 10, 0

        NULL = 0

        a dq 0
        x dq 0
        ;x dd 0

        y1 dq 0
        y2 dq 0
        y dq 0

        i dd 0
        n dd 10
        temp dd 0
        reminder dq 0

section '.idata' data import readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
        import kernel,\
               ExitProcess, 'ExitProcess'
          
        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'

section '.code' code readable writeable executable
start:
        ; Получить вещественные x и a
        invoke printf, input_x
        invoke scanf, input_float, x
        invoke printf, input_a
        invoke scanf, input_float, a

        invoke printf, output_newline

        looop:
                invoke printf, output_x, dword [ds:x], dword [ds:x+4]
                invoke printf, output_a, dword [ds:a], dword [ds:a+4]

                finit
                fld qword [ds:x] ; load x to st0
                fld qword [ds:a] ; load a to st1
                fcomip st1 ; compare st0 and st1
                je else_1 ; je - Jump if st0 == st1
                if_1: ; x <> a
                ;---- y1 = a - x -----
                      fld qword [ds:a]
                      fld qword [ds:x]
                      fsubp
                      fstp [ds:y1] ; store y1
                ;---------------------
                      jmp if_1_out
                else_1: ; x == a
                ; --- y1 = x + 3 ----
                      fld qword [ds:x]
                      mov [ds:temp], 3
                      fild dword [ds:temp]
                      fadd qword [ds:x]
                      fstp [ds:y1] ; store y1
                      if_1_out:

                finit
                fld qword [ds:a] ; load a to st0
                fld qword [ds:x] ; load x to st1
                fcomip st1  ; compare st0 and st1
                jbe else_2 ; Jump if st0 >= st 1
                if_2: ; a < x
                ;--- y2 = a - 1 ---
                     fld qword [ds:a]
                     fabs ; st0 = |st0|
                     fstp [ds:y2] ; store y2
                     ;--------------------
                     jmp if_2_out
                else_2: ;a >= x
                ;--- y2 = |a| - x ---
                     fld qword [ds:a]
                     fabs ; st0 = |st0|
                     fld qword [ds:x]
                     fsubp  ; st0 - st1 and pop stack
                     fstp [ds:y2] ; store y2
                     ;----------------
                     if_2_out:


                ;--- y = y1 + y2 -----
                fld qword [ds:y1]
                fld qword [ds:y2]
                fmulp
                fstp [ds:y]
                ;---------------------

                invoke printf, output_y1, dword [ds:y1], dword [ds:y1+4]
                invoke printf, output_y2, dword [ds:y2], dword [ds:y2+4]
                invoke printf, output_y, dword [ds:y], dword [ds:y+4]
                invoke printf, output_newline


                ;----- x++ -----------
                fld1
                fadd qword [ds:x]
                fstp [ds:x]
                ;---------------------


                ;---- i++; i < n -----
                mov ecx, [ds:i]
                inc ecx
                cmp ecx, [ds:n]
                mov [ds:i], ecx
                jne looop
                ;---------------------
  
  invoke getch
  
  invoke ExitProcess, 0
