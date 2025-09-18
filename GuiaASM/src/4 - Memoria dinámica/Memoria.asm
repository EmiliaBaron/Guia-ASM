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
	;prologo
	push rbp
	mov rbp, rsp

	xor r8, r8 

	.ciclo: 
		mov al, BYTE [rdi + r8]
		mov cl, BYTE [rsi + r8]

		mov dl, 0

		;chequear que a no sea null
		cmp al, dl 
		je .chequearBnulo
		
		;comparar a con b
		cmp al, cl 
		ja .devolverMenosUno
		jb .devolverUno
		;si son iguales
		inc r8 
		jmp .ciclo

		.chequearBnulo:
			cmp cl, dl 
			je .devolverCero
			ja .devolverUno

		.devolverCero:
			mov eax, 0
			jmp .epilogo

		.devolverUno:
		  	mov eax, 1
		  	jmp .epilogo

		.devolverMenosUno:
			mov eax, -1
			jmp .epilogo

	.epilogo:
	pop rbp
	ret

; char* strClone(char* a)
;a[rdi]
strClone:
	push rbp 
	mov rbp, rsp
	push rbx
	sub rsp, 8 

	xor r8, r8 ;indice/tamaño string
	.calcTamanioA:
		;NO MODIFICAR BL porque es NO VOLATIL AL PPORQUE ES PARTE DEL RAX
		mov bl, BYTE [rdi + r8]
		mov cl, 0
		inc r8
		cmp bl, cl 
		jne .calcTamanioA

	push r8 
	push rdi ; pila alineada

	mov rdi, r8 ; asumo que cuando pusheas no limpias el valor de r8 

	call malloc ; con rdi = tamaño string de a

	pop rdi
	pop r8

	xor r10, r10 
	
	.copiarString:
		mov bl, BYTE [rdi + r10]
		mov BYTE [rax + r10], bl
		inc r10 
		cmp r10, r8 
		jne .copiarString

	add rsp, 8
	pop rbx
	pop rbp
	ret 

; void strDelete(char* a)
strDelete:
	;prologo
	push rbp 
	mov rbp, rsp

	call free 

	pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
;x1[rdi]
;pfile[rsi]
strPrint:
	;prologo
	push rbp
	mov rbp, rsp

	mov al, BYTE [rdi]
	mov cl, 0
	cmp al, cl
	je .printNull

	;si no es null
	mov r10, rdi
	mov rdi, rsi 
	mov rsi, r10 ;intercambiar char* por FILE*
	call fprintf
	jmp .epilogo

	.printNull:
		mov rdi, rsi
		mov rsi, 'NULL'
		call fprintf 

	.epilogo:
	pop rbp
	ret

; uint32_t strLen(char* a)
strLen:
	;prologo
	push rbp
	mov rbp, rsp
	push rbx

	xor rax, rax ;indice/tamaño string
	mov cl, 0

	calcTamanio:
		;NO MODIFICAR AL PPORQUE ES PARTE DEL RAX
		mov bl, BYTE [rdi + rax]
		cmp bl, cl 
		je .caracNulo
		inc eax
		jmp calcTamanio

	.caracNulo:

	pop rbx
	pop rbp
	ret

; Displacement — An 8-bit, 16-bit, or 32-bit value.
; Base — The value in a 64-bit general-purpose register.
; Index — The value in a 64-bit general-purpose register.
; Scale factor — A value of 2, 4, or 8 that is multiplied by the index value.


