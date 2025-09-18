

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[rdi]
cantidad_total_de_elementos:
	;prologo
	push rbp
	mov rbp, rsp
	; preciclo
	XOR rax, rax ;cant de elementos
	mov rsi, QWORD [rdi] ; para tener el valor del puntero a nodo head

	.ciclo:
    	mov r8d, DWORD [rsi + NODO_OFFSET_LONGITUD ]
		add eax, r8d ;sumo cantidad de elementos de la lista

		mov rsi, QWORD [rsi + NODO_OFFSET_NEXT] ; paso al siguiente nodo

		; escala NODO_SIZE es de 2 4 8 bits , NODO_OFFSET 8 16 32 bits
		 				;avanzo el índice del array
		
		xor r9, r9 
    	CMP rsi, r9 ;si el next no es null, se sigue el conteo 
    	jne .ciclo

	; epilogo
	pop rbp
	ret 

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[rdi?]
cantidad_total_de_elementos_packed:
	;prologo
	push rbp
	mov rbp, rsp
	; preciclo
	XOR rax, rax ;cant de elementos
	mov rsi, QWORD [rdi] ; para tener el valor del puntero a nodo head

	.ciclo:
    	mov r8d, DWORD [rsi + PACKED_NODO_OFFSET_LONGITUD ]
		add eax, r8d ;sumo cantidad de elementos de la lista

		mov rsi, QWORD [rsi + PACKED_NODO_OFFSET_NEXT] ; paso al siguiente nodo

		; escala NODO_SIZE es de 2 4 8 bits , NODO_OFFSET 8 16 32 bits
		 				;avanzo el índice del array
		
		xor r9, r9 
    	CMP rsi, r9 ;si el next no es null, se sigue el conteo 
    	jne .ciclo

	; epilogo
	pop rbp
	ret 

