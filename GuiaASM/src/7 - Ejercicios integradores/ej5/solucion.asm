extern strcmp

; Definiciones comunes
TRUE  EQU 1
FALSE EQU 0

; Identificador del jugador rojo
JUGADOR_ROJO EQU 1
; Identificador del jugador azul
JUGADOR_AZUL EQU 2

; Ancho y alto del tablero de juego
tablero.ANCHO EQU 10
tablero.ALTO  EQU 5

; Marca un OFFSET o SIZE como no completado
; Esto no lo chequea el ABI enforcer, sirve para saber a simple vista qué cosas
; quedaron sin completar :)
NO_COMPLETADO EQU -1

extern strcmp

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
carta.en_juego EQU 0
carta.nombre   EQU 1
carta.vida     EQU 14
carta.jugador  EQU 16
carta.SIZE     EQU 18

tablero.mano_jugador_rojo EQU 0
tablero.mano_jugador_azul EQU 8
tablero.campo             EQU 16
tablero.SIZE              EQU ((50 +2)*8)

accion.invocar   EQU 0
accion.destino   EQU 8
accion.siguiente EQU 16
accion.SIZE      EQU 24

; Variables globales de sólo lectura
section .rodata

; Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - hay_accion_que_toque
global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE

; Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - invocar_acciones
global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE

; Marca el ejercicio 3 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contar_cartas
global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE

section .text

; Dada una secuencia de acciones determinar si hay alguna cuya carta tenga un
; nombre idéntico (mismos contenidos, no mismo puntero) al pasado por
; parámetro.
;
; El resultado es un valor booleano, la representación de los booleanos de C es
; la siguiente:
;   - El valor `0` es `false`
;   - Cualquier otro valor es `true`
;
; ```c
; bool hay_accion_que_toque(accion_t* accion, char* nombre);
; ```
global hay_accion_que_toque
hay_accion_que_toque:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = accion_t*  accion
	; rsi = char*      nombre
	push rbp 
	mov rbp, rsp
	push r12
	push r13 ; alin

	;preservamos
	mov r12, rdi ; accion
	mov r13, rsi ; nombre
	
	recorrerAcciones: 
		;ver si accion no es null 
		cmp r12, 0 
		je devolverCero

		;acceder a la carta destino
		mov r8, QWORD [r12 + accion.destino] ; puntero carta destino
		;preparar strcmp
		;acceder a su nombre
		mov rdi, r8 
		add rdi, carta.nombre

		mov rsi, r13 ; asegurarse nombre

		call strcmp

		cmp rax, 0 ; si son iguales
		je devolverUno

		; si no son iguales
		;acceder a siguiente accion
		mov r9, QWORD [r12 + accion.siguiente]
		mov r12, r9 ; puntero nueva accion
		jmp recorrerAcciones


	devolverCero: 
		mov rax, 0 
		jmp epilogoA 

	devolverUno:
		mov rax, 1

	epilogoA: 

	pop r13
	pop r12
	pop rbp
	ret

; Invoca las acciones que fueron encoladas en la secuencia proporcionada en el
; primer parámetro.
;
; A la hora de procesar una acción esta sólo se invoca si la carta destino
; sigue en juego.
;
; Luego de invocar una acción, si la carta destino tiene cero puntos de vida,
; se debe marcar ésta como fuera de juego.
;
; Las funciones que implementan acciones de juego tienen la siguiente firma:
; ```c
; void mi_accion(tablero_t* tablero, carta_t* carta);
; ```
; - El tablero a utilizar es el pasado como parámetro
; - La carta a utilizar es la carta destino de la acción (`accion->destino`)
;
; Las acciones se deben invocar en el orden natural de la secuencia (primero la
; primera acción, segundo la segunda acción, etc). Las acciones asumen este
; orden de ejecución.
;
; ```c
; void invocar_acciones(accion_t* accion, tablero_t* tablero);
; ```
global invocar_acciones
invocar_acciones:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = accion_t*  accion
	; rsi = tablero_t* tablero
	push rbp 
	mov rbp, rsp
	push r12
	push r13 ;alin 
	push r14 
	sub rsp, 8 

	;preservar
	mov r12, rdi ; accion 
	mov r13, rsi ; tablero

	recorrerSecuencia: 
		cmp r12, 0  ; si accion null
		je terminarSecuencia

		;acceder a carta destino 
		mov r14, QWORD [r12 + accion.destino] ; puntero carta destino
		;acceder a en juego
		mov r9b , BYTE [r14 + carta.en_juego] ; en juego 

		cmp r9b, 0 
		je siguienteAccion

		; si esta en juego
		; preparase para invocar accion
		mov r10, QWORD [ r12 + accion.invocar]
		mov rdi, r13
		mov rsi, r14 ; carta destino

		call r10 

		;acceder vida carta destino
		mov r11w, WORD [r14 + carta.vida]

		cmp r11w, 0
		jg siguienteAccion 

		;si tiene 0 o menos de vida
		;acceder a en juego
		mov BYTE [r14 + carta.en_juego], 0
		
		siguienteAccion: 
			mov r8, QWORD [r12 + accion.siguiente] 
			mov r12 ,r8 ; puntero a siguiente accion
			jmp recorrerSecuencia


	terminarSecuencia: 

	add rsp, 8
	pop r14
	pop r13
	pop r12
	pop rbp 
	ret

; Cuenta la cantidad de cartas rojas y azules en el tablero.
;
; Dado un tablero revisa el campo de juego y cuenta la cantidad de cartas
; correspondientes al jugador rojo y al jugador azul. Este conteo incluye tanto
; a las cartas en juego cómo a las fuera de juego (siempre que estén visibles
; en el campo).
;
; Se debe considerar el caso de que el campo contenga cartas que no pertenecen
; a ninguno de los dos jugadores.
;
; Las posiciones libres del campo tienen punteros nulos en lugar de apuntar a
; una carta.
;
; El resultado debe ser escrito en las posiciones de memoria proporcionadas
; como parámetro.
;
; ```c
; void contar_cartas(tablero_t* tablero, uint32_t* cant_rojas, uint32_t* cant_azules);
; ```
global contar_cartas
contar_cartas:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = tablero_t* tablero
	; rsi = uint32_t*  cant_rojas
	; rdx = uint32_t*  cant_azules
	push rbp 
	mov rbp, rsp 
	push r12
	sub rsp, 8
	

	;acceder al campo 
	mov rcx, rdi 
	add rcx, tablero.campo

	;asignar cero a contadores
	mov DWORD [rsi], 0
	mov DWORD [rdx], 0
	
	xor r8, r8 ; indice

	recorrerTablero: 
		cmp r8, 10*5
		je terminarTablero

		mov r12, QWORD [rcx + r8 * 8] ; puntero a carta

		cmp r12, 0 
		je incrementarIndiceT

		;acceder a jugador dueño 
		mov r10b, BYTE [r12 + carta.jugador]

		cmp r10b, 1
		je incrementarRojo 

		cmp r10b, 2
		je incrementarAzul 

		jmp incrementarIndiceT

		incrementarRojo:
			inc DWORD [rsi]
			jmp incrementarIndiceT

		incrementarAzul: 
			inc DWORD [rdx]
		
		incrementarIndiceT:
			inc r8 
			jmp recorrerTablero

		terminarTablero:

	add rsp, 8
	pop r12
	pop rbp 
	ret
