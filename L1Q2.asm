
section .data

	menu: db 'Digite um inteiro para calcular se é primo', 10
	sizemenu: equ $-menu ;$

	primo: db 'O numero inserido eh primo', 10
	sizeprimo: equ $-primo ;$

	naoprimo: db 'O numero inserido NAO eh primo', 10
	sizenaoprimo: equ $-naoprimo ;$


section .bss
	buffer: resb 20
	number: resd 1
	resultados: resd 1

section .text
	global _start

_start:
	mov eax, 4			;sys_write
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

	
	mov ecx, 1
	xor ebx, ebx 			;utilizar ebx como acumulador de resultados
CALC: 	xor edx, edx
	xor eax, eax 
	mov eax, [number]		;reset 
	div ecx				;edx = eax%ecx (resto)

	cmp edx, 0
	jne saida
		
	inc ebx				;é divisor
saida:	
	inc ecx
	cmp ecx, [number]
	JLE CALC
	
	cmp ebx, 2			;Verifica se é divisivel apenas por 1 e por ele mesmo
	jne NPRIMO


PRIMO:	mov EAX, 4
 	mov EBX, 1 
 	mov ECX, primo
 	mov EDX, sizeprimo
 	int 80h

 	jmp exit

NPRIMO:	mov EAX, 4 
 	mov EBX, 1
 	mov ECX, naoprimo
 	mov EDX, sizenaoprimo
 	int 80h
	
exit:	mov EAX, 1
	mov EBX, 0
	int 80h
