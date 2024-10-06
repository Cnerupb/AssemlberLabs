format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

	inputX db 'Enter X: ', 0
	inputY db 'Enter Y: ', 0
	formatNum db '%d', 0
	result db "Result is %d",0


	NULL = 0

	X dd ?
	Y dd ?
       ; Z dd ?

section '.idata' data import readable
	library kernel, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'

	import kernel, \
	       ExitProcess, 'ExitProcess'

	import msvcrt, \
	       printf, 'printf', \
	       getch, '_getch', \
	       scanf, 'scanf'

section '.code' code readable writeable executable
start:
	; Insert x
	push inputX
	call [printf]

	push X
	push formatNum
	call [scanf]

	; Insert y
	push inputY
	call [printf]

	push Y
	push formatNum
	call [scanf]

	; 14. ((X+Y)/Y^2 - 1)*X
	mov eax, [X]			 ; Перенос значения X в регистр EAX. Теперь EAX содержит X
	mov ecx, [Y]			 ; Перенос значения Y в регистр ECX. Теперь ECX содержит Y

	add eax, ecx			 ; X + Y
	mov ecx, [Y]			 ; Перенос значения Y в регистр ECX. Теперь ECX содержит Y
	imul ecx, [Y]			 ; Y ^ 2
	cdq				 ; double the size of value AX or EAX register respectively and store the extra bits into the DX or EDX register. Без этой инструкции не работает idiv
	idiv ecx			 ; EAX целочисленно поделить на ECX. Результат оставить в EAX. (X + Y) / (Y ^ 2)
	sub eax, 1			 ; Из EAX вычесит 1. Результат оставить в EAX.	((X + Y) / (Y ^ 2)) - 1
	mov ecx, [X]
	imul eax, ecx			 ; Умножить EAX на ECX. Результат оставить в EAX. (((X + Y) / (Y ^ 2)) - 1) * X


	; Вывод Z
	push eax
	push result
	call [printf]

	call [getch]

	push NULL
	call [ExitProcess]