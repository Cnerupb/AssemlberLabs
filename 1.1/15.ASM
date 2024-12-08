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

	; 15. Z = (X-Y)/(XY+1)
	mov eax, [X]			 ; ������� �������� X � ������� EAX. ������ EAX �������� X
	mov ecx, [Y]			 ; ������� �������� Y � ������� ECX. ������ ECX �������� Y

	sub eax, ecx			 ; �������� �� EAX �������� � �������� ECX. (X - Y). ��������� ��������� � EAX
	imul ecx, [X]			 ; �������� ECX �� X. ��������� �������� � ECX. (X * Y)
	add ecx, 1			 ; �������� � ECX 1. ��������� �������� � ECX. ((X * Y) + 1)
	cdq				 ; double the size of value AX or EAX register respectively and store the extra bits into the DX or EDX register. ��� ���� ���������� �� �������� idiv
	idiv ecx			 ; EAX ������������ �������� �� ECX. ��������� �������� � EAX. (X - Y) / ((X * Y) + 1)

	; ����� Z
	push eax
	push result
	call [printf]

	call [getch]

	push NULL
	call [ExitProcess]