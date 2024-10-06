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

	;17. Z = Y^2 + XY + X/Y
	mov eax, [X]			 ; Перенос значения X в регистр EAX. Теперь EAX содержит X
	mov ecx, [Y]			 ; Перенос значения Y в регистр ECX. Теперь ECX содержит Y

	mov eax, [X]
	mov ecx, [Y]
	cdq				 ; double the size of value AX or EAX register respectively and store the extra bits into the DX or EDX register. Без этой инструкции не работает idiv
	idiv ecx			 ; X/Y

	mov ebx, [X]
	imul ebx, [Y]			 ; X*Y
	add eax, ebx			 ; (X/Y) + (X*Y)

	mov ebx, [Y]
	imul ebx, [Y]			 ; Y^2
	add eax, ebx			 ; (X/Y) + (X*Y) + (Y^2)

	; Вывод Z
	push eax
	push result
	call [printf]

	call [getch]

	push NULL
	call [ExitProcess]