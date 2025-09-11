

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 16
PACKED_NODO_OFFSET_LONGITUD EQU 24
PACKED_NODO_SIZE EQU 28
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
	XOR rax, rax ;cant de elementos

	.ciclo:
    	mov rsi, [RDI + rax * NODO_SIZE + NODO_OFFSET_NEXT]
		add rax, NODO_SIZE 				;avanzo el índice del array
		
		xor r8d, r8d 
    	CMP R8, RSI 
    	jne .ciclo

	ret 

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[rdi?]
cantidad_total_de_elementos_packed:
	XOR rax, rax ;cant de elementos

	.ciclo:
    	mov rsi, [RDI + rax * PACKED_NODO_SIZE + PACKED_NODO_OFFSET_NEXT]
		add rax, PACKED_NODO_SIZE 				;avanzo el índice del array
		
		xor r8d, r8d 
    	CMP R8, RSI 
    	jne .ciclo

	ret

