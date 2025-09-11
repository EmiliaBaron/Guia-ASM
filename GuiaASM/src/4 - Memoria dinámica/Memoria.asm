extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; a[rdi] 
; b[rsi]
strCmp:
	xor xor r8, r8 

	.ciclo 
		mov al BYTE [rdi + r8]
		mov bl BYTE [rdi + r8]

		mov cl '\0'

		cmp al cl 
		je .chequearBnulo
		
		;comparar a con b
		cmp al bl 
		ja .devolver-1
		jb .devolver1
		;si son iguales
		inc r8 
		jmp .ciclo

		.chequearBnulo
			cmp bl cl 
			je .devolver0
			ja .devolver1

		.devolver0
			mov eax, 0
			jmp .epilogo

		.devolver1
		  	mov eax, 1
		  	jmp .epilogo

		.devolver-1
			mov eax, -1
			jmp .epilogo

	.epilogo
	ret

; char* strClone(char* a)
;a[rdi]
strClone:
	push rbp 
	mov rbp, rsp

	xor r8, r8 ;indice/tamaño string
	.calcTamanioA
		mov al BYTE [rdi + r8]
		mov cl '\0'
		cmp al cl 
		inc r8
		jne .calcTamanioA

	push r8 
	push rdi ; pila alineada

	mov rdi r8 ; asumo que cuando pusheas no limpias el valor de r8 

	call malloc ; con rdi = tamaño string de a

	pop rdi
	pop r8

	xor r10, r10 
	
	.copiarString
		mov al, BYTE [rdi + r10]
		mov BYTE [rax + r10], al
		inc r10 
		cmp r10 r8 
		jne .copiarString

	pop rbp
	ret 

; void strDelete(char* a)
strDelete:
	

	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	ret


