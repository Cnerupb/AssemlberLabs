format PE console 4.0

entry start

include 'win32a.inc'

; ����������� ������� ������ ��� ����� ������
define  string_buf  512

;=======================================================
section '.data' data readable writable
;=======================================================

        ; char_print         db   '%c', 0                     ; ������ ��� ������ �������
        msg_string         db   'Enter string: ', 10, 0     ; ��������� ��� ������������ ��� ������� ������
        output_words_len   db   'Words len: %d', 10, 0
        output_string_len  db   'String len: %d', 10, 0
        output_string_wc   db   'Word count: %d', 10, 0
        output_string_full_len db 'String len except end symbol: %d', 10, 0
        output_float       db   'Result is %5.5f', 10, 0
        input_string       db   string_buf dup(0)           ; ����� ��� �������� ��������� ������
        len_string         dd   0                           ; ����� ������
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

; ��������� �������� ������� �����
count_words:
    cld ; DL = 0                ; ������� ���� ����������� ��� ����������� �������� �� ������
    mov   ax, ds                ; ��������� ������� ������ � ES
    mov   es, ax
    lea   edi, [input_string]   ; ��������� ����� ������ � ������� EDI
    mov   al, 0                 ; ������������� �������� AL � 0 ��� ������ ����� ������ (null-�������)
    mov   ecx, string_buf       ; ������������� ������ ������ ECX ��� ������ ����� ������
    repnz scasb                 ; ���� null-������ � ������

    mov   eax, string_buf       ; ������������ ����� ������
    sub   eax, ecx
    mov   [len_string], eax     ; ��������� ����� ������
    mov   ecx, eax              ; ��������� ����� ������ � ECX ��� ���������� ������
    mov   ebx, ecx              ; ��������� ��������� �������� ECX � EBX (����� ��� ������� ����� ����)
    ; mov   edx, 0                ; �������������� ������������ ����� ����� � EDX (���� 0)
    mov   edx, 0                ; � EDX ����� ������� ����� ���� ����
    lea   edi, [input_string]   ; ����� ��������� ����� ������ � EDI ��� ������ ������ ����

    ; ���� ������ ����
    find_word:
      mov   al,  32             ; ������������� AL ������ ������� (��� ������� 32)
      ; repz scasb
      repnz scasb               ; ���� ��������� ������ ��� ����� ������
      mov   eax, ebx            ; ������������ ����� �������� �����
      sub   eax, ecx
      dec   eax                 ; ��������� ������
      add edx, eax              ; ���������� ������ ����� � EDX
      end_count:
        mov   ebx, ecx            ; ��������� ������� �������� ECX � EBX ��� ��������� ��������
      
        cmp   ecx, 0              ; ���� ����� ������ �� ���������, ���������� ����
        jne   find_word
    mov [len_words], edx       ; ���������� ��������� ����� ���� � ����������
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

    ; �������_�����_����� = ���������_�����_����_���� / (�����_�����_������ - ���������_�����_����_���� + 1)
    mov eax, [len_string_woes]
    mov ebx, [len_words]
    sub eax, ebx
    inc eax
    mov [word_count], eax
    invoke printf, output_string_wc, [word_count]

    ; ������� ������� ����� �����
    finit
    fild dword [ds:word_count]
    fild dword [ds:len_words]
    fdiv st0, st1
    fstp qword [ds:average_word_len]

    ; ������� ������� ����� �����
    invoke printf, output_float, dword [ds:average_word_len], dword [ds:average_word_len+4]

    invoke getch                    ; �������� ������� �������
    invoke ExitProcess, 0           ; ��������� ���������

    
; ����� �����    
start:
    
    cinvoke printf, msg_string      ; ������� ��������� ��� ����� ������
    cinvoke gets, input_string      ; �������� ���� �� ������������
    call count_words                ; �������� ��������� �������� ����� �����
    call print_result           ; �������� ��������� ������ ������ �������� �����
    invoke getch                    ; �������� ������� �������
    invoke ExitProcess, 0           ; ��������� ���������