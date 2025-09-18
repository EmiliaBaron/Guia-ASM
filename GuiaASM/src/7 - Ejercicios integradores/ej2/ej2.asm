extern malloc

extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - optimizar
global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

global optimizar
optimizar:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = mapa_t           mapa
	; rsi = attackunit_t*    compartida
	; rdx = uint32_t*        fun_hash(attackunit_t*)

	push rbp ;ali
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15 ; ali
	push rbx 
	sub rsp, 8

	;movemos a registros no vol
	mov r12, rdi ; mapa
	mov r13, rsi ; compartida
	mov r14, rdx ; fun_hash

	mov rdi, r13
	call r14 ; llama func con compartida

	mov r15, rax ; hashComp

	mov r8, 0 ; indice

	recorrerMapa:
		cmp r8, 255 * 255
		je terminarRecorridoA

		mov rbx, QWORD [r12 + r8 * 8] ;puntero o null 

		cmp rbx, 0 ;puntero null
		je incrementIndice 

		cmp rbx, r13 ; si puntero = puntero comp
		je incrementIndice

		push r8
		sub rsp, 8

		mov rdi, rbx 
		call r14 ;rax -> hashPuntero

		add rsp, 8
		pop r8

		cmp rax, r15 ;comp hashes
		jne incrementIndice 
		;PROBLEMA CON LOS PUNTEROS, NO CON LOS HASHES
		mov QWORD [r12 + r8 * 8 ], r13 ; mapa <- compartida

		inc BYTE [r13 + ATTACKUNIT_REFERENCES] ; comp->ref++ 

		dec BYTE [rbx + ATTACKUNIT_REFERENCES] ;decrementa ref puntero
	 
		cmp BYTE [rbx + ATTACKUNIT_REFERENCES], 0 
		jg incrementIndice
		 
		push r8
		sub rsp, 8

		mov rdi, rbx 
		call free ; libera puntero

		add rsp, 8
		pop r8		

		incrementIndice: 
			inc r8
			jmp recorrerMapa

	terminarRecorridoA:
		mov dil, BYTE [r13 + ATTACKUNIT_REFERENCES]
		cmp dil, 0
		jg epilogoA

		mov rdi, r13 
		call free ; libera puntero unidad compartida si no hubo punteros iguales 		CREO QUE ES AL PEDO

	epilogoA:
		add rsp, 8
		pop rdx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		
		ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; rdi = mapa_t           mapa
	; rsi = uint16_t*        fun_combustible(char*)

	push rbp ; alin
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15 ;alin
	push rbx 
	sub rsp, 8 ; alin

	;presevo
	mov r12, rdi ; mapa
	mov r13, rsi ; func

	xor r14, r14 ; reserva

	xor r15, r15 ; indice
	recorrerMapaB: 
		cmp r15, 255 * 255
		je finRecorridoB

		mov rbx, QWORD [r12 + r15 * 8] ; puntero a unit

		cmp rbx, 0  ; null
		je incrementIndiceB

		mov r8W, WORD [rbx + ATTACKUNIT_COMBUSTIBLE] ; comb base

		push r8
		sub rsp ,8 

		mov rdi, rbx
		;add rdi, ATTACKUNIT_CLASE ; rdi puntero array clase
		call r13 ; ax -> combustible a asig     quiere un puntero a un ARRAY DE charS 

		add rsp, 8
		pop r8

		;mov WORD [rbx + ATTACKUNIT_COMBUSTIBLE], ax ; asig combustible a unit
		; POR UN MOTIVO NO ANDA LA INSTRUCCION??? PEGA CUALQUIER COSASASDW

		sub r8w, ax   ; comb base - comb asign
		add r14w, r8w ; 

		incrementIndiceB:
			inc r15
			jmp recorrerMapaB


	finRecorridoB:
	mov rax, r14


	epilogoB:
		add rsp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

global modificarUnidad
modificarUnidad:
	; rdi = mapa_t           mapa
	; rsi  = uint8_t          x
	; rdx  = uint8_t          y
	; rcx = void*            fun_modificar(attackunit_t*)
	push rbp ;alin
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15 ;alin
	push rbx 
	sub rsp, 8 ;alin

	;preservo
	mov r12, rdi ;mapa 
	mov r13, rsi ;x
	mov r14, rdx ;y
	mov r15, rcx ; fun mod

	mov rax, r13
	mov r11, (255*8)
	mul r11 ; supuestamente = (r13*(255 * 8))

	mov r13, rax

	; push r11
	; sub rsp, 8 
	 
	mov rax, r14
	mov r9, 8
	mul r9

	; add rsp, 8
	; pop r11

	add r13, rax ; -> r13 ahora offset

	mov rbx, QWORD [r12 + r13] ; seguro esto revienta (puntero de posicion)

	cmp rbx, 0 
	je epilogoC ; si es null no se hace nada

	cmp BYTE [rbx + ATTACKUNIT_REFERENCES], 1
	je unaRefe
	; refe >1 (asumo que es la unica otra opcion)
	dec BYTE [rbx + ATTACKUNIT_REFERENCES]

	mov rdi, (ATTACKUNIT_SIZE )

	call malloc ; rax -> nuevo puntero

	mov r14, rax ; -> preservo el puntero pisando y 

	xor r8, r8 ; indice
	copiarClase: 
		cmp r8, 11
		je finCopiado
		
		mov r9w, WORD [rbx + r8 + ATTACKUNIT_CLASE] ;copia char clase

		mov BYTE [rax + r8 + ATTACKUNIT_CLASE], r9b ;pega char en clase nuevo puntero

		inc r8
		jmp copiarClase

	finCopiado: 

		mov r10w, WORD [rbx + ATTACKUNIT_COMBUSTIBLE]

		mov WORD [rax + ATTACKUNIT_COMBUSTIBLE], r10w ; copio combustible

		mov BYTE [rax + ATTACKUNIT_REFERENCES], 1 ; referencia = 1 nuevo puntero

		mov QWORD [r12 + r13], r14 ; nuevo puntero en mapa

		mov rdi, rax
		call r15 ; funcion mod

		jmp epilogoC

	unaRefe: 
		mov rdi, rbx
		call r15
	
	epilogoC:
		add rsp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret



