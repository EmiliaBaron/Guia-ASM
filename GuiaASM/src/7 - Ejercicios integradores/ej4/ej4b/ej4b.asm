extern strcmp
global invocar_habilidad

; Completar las definiciones o borrarlas (en este ejercicio NO serán revisadas por el ABI enforcer)
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text

; void invocar_habilidad(void* carta, char* habilidad);
invocar_habilidad:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = void*    card ; Vale asumir que card siempre es al menos un card_t*
	; rsi = char*    habilidad
	push rbp 
	mov rbp, rsp
	push r12
	push r13 ; alin 
	push r14
	push r15 ; alin
	push rbx
	sub rsp, 8

	;preservo
	mov r12, rdi ; card
	mov r13, rsi ; habilidad

	comenzarBusquedaHabilidad:

		;acceder al dir de la carta
		mov r14, QWORD [r12 + FANTASTRUCO_DIR_OFFSET] ; puntero directorio
		;acceder a dir entries
		xor r15, r15
		mov r15w, WORD [r12 + FANTASTRUCO_ENTRIES_OFFSET] ;dir entries

		xor rbx, rbx ; indice

		recorrerDir: 
			cmp rbx, r15
			je finRecorridoDir

			;acceder a puntero dir entry
			mov r8, QWORD [r14 + rbx * 8] 
			add r8, DIRENTRY_NAME_OFFSET; puntero char entry

			;preparar strcmp
			mov rdi, r8 ;puntero al char de dir entry
			mov rsi, r13

			call strcmp 

			cmp rax, 0 
			je invocarHabilidad

			incrementIndiceDir: 
				inc rbx; puntero a dir entry
				jmp recorrerDir


		finRecorridoDir:
			mov rdi, QWORD [r12 + FANTASTRUCO_ARCHETYPE_OFFSET]
			
			cmp rdi, 0 
			je noSeEncontroHabilidad

			mov r12, rdi
			jmp comenzarBusquedaHabilidad

	invocarHabilidad:
		; chequear si carta no esta dormida
		;cmp BYTE [r12 + FANTASTRUCO_FACEUP_OFFSET], 0
		;je noSeEncontroHabilidad ; en realidad no se ejecuta

		;quiere un ghost_trick card 
		mov rdi, r12
		mov r10, QWORD [r14 + rbx* 8 ] ; puntero a 
		mov r11, [r10 + DIRENTRY_PTR_OFFSET]  ; puntero a funcion
		; se tiene que acceder al puntero para acceder a la funcion

		call r11
 

	noSeEncontroHabilidad: 

	add rsp, 8
	pop rbx
	pop r15 
	pop r14
	pop r13
	pop r12
	pop rbp 
	ret ;No te olvides el ret!
