
section .data
	menu: db 'Digite um inteiro para repetir a frase "Infra estrutura de Software" n vezes.', 10
	sizemenu: equ $-menu ;$

	msg: db 'Infraestrutura de Software', 10
	sizemsg: equ $-msg ;$


section .bss
	buffer: resb 20
	number: resd 1
	contador: resd 1
	
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

	mov ecx, 0	
loop:	mov dword [contador], ecx

	mov eax, 4
 	mov ebx, 1 
 	mov ecx, msg
 	mov edx, sizemsg
 	int 80h
	
	xor ecx, ecx
	mov ecx, [contador]

	inc ecx
	cmp ecx, [number]
	JL loop
	
exit:	mov EAX, 1
	mov EBX, 0
	int 80h
