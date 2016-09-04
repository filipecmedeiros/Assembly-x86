
section .data
	menu: db 'Digite um inteiro para calcular a sequencia de fibonacci', 10
	sizemenu: equ $-menu ;$

section .bss
	buffer: resb 20
	number: resd 1
	fibonacci: resd 1
	result: resb 10
	
section .text
	global _start

_start:	mov eax, 4			;sys_write
	mov ebx, 1
	mov ecx, menu
	mov edx, sizemenu
	int 80h

	mov eax, 3			;sys_read
	mov ebx, 0
	mov ecx, buffer
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

	mov ecx, eax 			;contador
FIBON:	dec ecx
	add eax, ecx
	cmp ecx, 0
	jne FIBON
	mov [fibonacci], eax
	
	mov eax, [fibonacci]
	mov ebx, 10
	xor ecx, ecx
DESCONV:xor edx, edx
	div ebx
	add dl, '0'
	mov [result+ecx], dl
	inc ecx
	cmp eax,0
	jne DESCONV
	;aqui o resultado ainda está invertido e precisa ser concertado
INVER:	xor ebx, ebx
	mov al, [result+ebx]
	mov dl, [result+ecx]
	mov [result+ecx], al
	mov [result+ebx], dl
	inc ebx
	dec ecx
	cmp ebx, ecx
	jl INVER
	
	mov eax, 4			;sys_write
	mov ebx, 1
	mov ecx, result
	mov edx, 10
	int 80h
		
exit:
	mov EAX, 1
	mov EBX, 0
	int 80h
