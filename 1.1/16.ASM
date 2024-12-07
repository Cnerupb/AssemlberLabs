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

	; 16. Z = - X/Y+Y^2 + 3
	mov eax, [X]			 ; ������� �������� X � ������� EAX. ������ EAX �������� X
	mov ecx, [Y]			 ; ������� �������� Y � ������� ECX. ������ ECX �������� Y

	cdq				 ; double the size of value AX or EAX register respectively and store the extra bits into the DX or EDX register. ��� ���� ���������� �� �������� idiv
	idiv ecx			 ; ������������� ������ EAX �� ECX. �������� ��������� � EAX. (X/Y)
	imul eax, -1			 ; (X/Y) * (-1)

	mov ecx, [Y]
	imul ecx, [Y]			 ; (Y^2)

	add eax, ecx			 ; (-X/Y) + (Y^2)
	add eax, 3			 ; (-X/Y) + (Y^2)

	; ����� Z
	push eax
	push result
	call [printf]

	call [getch]

	push NULL
	call [ExitProcess]