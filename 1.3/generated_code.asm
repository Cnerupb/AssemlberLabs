
format PE console

entry start

include 'win32ax.inc'

section '.data' data readable writable
    a db 55, 12, 60, 12, 54, 23, 78, 99, 44
    summa dd 0
    max_summa dd -1
    max_summa_i dd -1
    min_summa dd -1
    min_summa_i dd -1
    b db 0, 0, 0, 0, 0, 0
    format_1 db "Vector b:", 10, 0
    format_elem db "%d, ", 0
    format_end db "%d]", 0

section '.text' code readable executable

start:
    ; Initialize loop variables
    mov ecx, 0          ; i = 0
outer_loop:
    cmp ecx, 3
    jge end_outer_loop  ; if i >= 3, exit loop

    ; Reset summa for each row
    mov eax, 0          ; summa = 0
    mov ebx, 0          ; j = 0
inner_loop:
    cmp ebx, 3
    jge check_sum       ; if j >= 3, check sums

    ; Add a[i][j] to summa
    movzx edx, byte [a + ecx*3 + ebx]
    add eax, edx
    inc ebx
    jmp inner_loop

check_sum:
    ; Check for max_summa
    cmp dword [max_summa], -1
    je set_max
    cmp eax, dword [max_summa]
    jle check_min
set_max:
    mov dword [max_summa], eax
    mov dword [max_summa_i], ecx
check_min:
    ; Check for min_summa
    cmp dword [min_summa], -1
    je set_min
    cmp eax, dword [min_summa]
    jge reset_summa
set_min:
    mov dword [min_summa], eax
    mov dword [min_summa_i], ecx

reset_summa:
    ; Reset summa for next iteration
    mov dword [summa], 0
    inc ecx
    jmp outer_loop

end_outer_loop:
    ; Fill vector b with alternating elements
    mov ecx, 0          ; i = 0
    mov ebx, 0          ; j = 0
fill_vector:
    cmp ebx, 3
    jge print_vector     ; if j >= 3, print vector

    ; b[i] = a[max_summa_i][j]
    movzx edx, byte [a + dword [max_summa_i]*3 + ebx]
    mov [b + ecx], dl
    inc ecx

    ; b[i+1] = a[min_summa_i][j]
    movzx edx, byte [a + dword [min_summa_i]*3 + ebx]
    mov [b + ecx], dl
    inc ecx

    inc ebx
    jmp fill_vector

print_vector:
    ; Print vector b
    ; Print "?????? b:"
    ; (Assuming a syscall or a function to print strings is available)
    ; Print format
    ; Print b[0]
    ; Print loop for b[1] to b[4]
    ; Print b[5]

    ; Exit program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; status: 0
    int 0x80

