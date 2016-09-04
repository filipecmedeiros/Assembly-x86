section .data
	menu: db "Digite um inteiro entre 0 e 1000", 10
	sizemenu: equ $-menu ;$
	
	par: db "O valor eh par", 0
	sizepar: equ $-par ;$
	
	impar: db "O valor eh impar", 0
	sizeimpar: equ $-impar ;$

	base: dd 10
		
section .bss
	buffer: resb 20
	number: resd 1
	
section .text
	global _start
	_start:
MENU:	mov eax, 4		;sys_write
	mov ebx, 1
	mov ecx, menu
	mov edx, sizemenu
	int 80h
	
	mov eax, 3		;sys_read
	mov ebx, 0		
	mov ecx, buffer		;Apos o system call eax contem o numero de bytes lidos
	int 80h

	;Funcao que converte string pra int
	mov edi, eax			;edi = tamanho da string em bytes
	dec edi				;decremento para fazer o contador de 0 a n-1
	xor eax, eax			;eax = 0	
	xor ecx, ecx			;ecx = 0 -> contador
	mov esi, 10			;base do calculo
CONV:	xor ebx, ebx			;ebx = 0 ->não pegar lixo
	mov byte bl, [buffer+ecx]	;pega o caractere
	inc ecx				;ecx++
	sub bl, '0'			;transforma em int
	imul esi			;eax = eax*10
	add eax, ebx			;"concatena" o caracter
	cmp edi, ecx			;do while (ecx != edi)
	jne CONV
	mov [number], eax		;armazena de volta na memória
		
	xor edx, edx		;edx = 0
	mov ebx, 2		;base para dividir
	idiv ebx		;edx = eax%2
	cmp edx, 0		;if(edx == 0)->par
	jne IMPAR		;else->impar

PAR:	mov eax, 4
	mov ebx, 1
	mov ecx, par
	mov edx, sizepar
	int 80h
	jmp exit
	
IMPAR:	mov eax, 4
	mov ebx, 1
	mov ecx, impar
	mov edx, sizeimpar
	int 80h

exit:	mov eax, 1
	mov ebx, 0
	int 80h
	
