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
	mov eax, [X]			 ; ������� �������� X � ������� EAX. ������ EAX �������� X
	mov ecx, [Y]			 ; ������� �������� Y � ������� ECX. ������ ECX �������� Y

	add eax, ecx			 ; X + Y
	mov ecx, [Y]			 ; ������� �������� Y � ������� ECX. ������ ECX �������� Y
	imul ecx, [Y]			 ; Y ^ 2
	cdq				 ; double the size of value AX or EAX register respectively and store the extra bits into the DX or EDX register. ��� ���� ���������� �� �������� idiv
	idiv ecx			 ; EAX ������������ �������� �� ECX. ��������� �������� � EAX. (X + Y) / (Y ^ 2)
	sub eax, 1			 ; �� EAX ������� 1. ��������� �������� � EAX.	((X + Y) / (Y ^ 2)) - 1
	mov ecx, [X]
	imul eax, ecx			 ; �������� EAX �� ECX. ��������� �������� � EAX. (((X + Y) / (Y ^ 2)) - 1) * X


	; ����� Z
	push eax
	push result
	call [printf]

	call [getch]

	push NULL
	call [ExitProcess]