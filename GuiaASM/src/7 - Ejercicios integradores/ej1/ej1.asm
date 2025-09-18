extern malloc

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
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
es_indice_ordenado:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = item_t**     inventario
	; rsi = uint16_t*    indice
	; rdx = uint16_t     tamanio
	; rcx = comparador_t comparador

	push rbp ;alin
	mov rbp, rsp
	push r12 ;
	push r13 ; alin
	push r14
	push r15 ; alin
	push rbx
	sub rsp, 8 ; alin

	;preservamos 
	mov r12, rdi ;invent
	mov r13, rsi ;indice
	mov r14, rdx ;tamanio
	mov r15, rcx ;comp

	xor rbx, rbx ; i
	sub r14, 2 ; le resto uno al tamaño
	cmp r14, 1
	jle devuelveTrue

	recorrerIndices:  
		cmp rbx, r14
		je devuelveTrue

		xor rcx, rcx ; un indice
		mov cx, WORD [r13 + rbx * 2] ; un indice
		mov rdi, QWORD [r12 + rcx *8] ; item1

		mov cx, WORD [r13 + (rbx + 1)* 2] ; un indice
		mov rsi, QWORD [r12 + rcx *8 ] ; item2

		call r15 

		cmp rax, 0
		je devuelveFalse

		inc rbx
		jmp recorrerIndices		

	devuelveTrue: 
		mov rax, 1
		jmp epilogo1

	devuelveFalse:
		mov rax, 0
		jmp epilogo1

	;epilogo
	epilogo1: 
		add rsp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp

		ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**

global indice_a_inventario
indice_a_inventario:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = item_t**  inventario
	; rsi = uint16_t* indice
	; rdx = uint16_t  tamanio

	push rbp 
	mov rbp, rsp
	push r12
	push r13
	push r14
	sub rsp, 8

	;movemos los parametros a no vol
	mov r12, rdi ; inven
	mov r13, rsi ; indice
	mov r14, rdx ; tamanio

	mov rax, rdx ; operaciones con mul: primer op en rax 
	mov r8, 8
	mul r8
	mov rdi, rax
	call malloc ;malloc con tamaño resultado 
	;no modificar el rax 
	
	xor r8, r8
	recorrerIndice:
		cmp r8, r14
		je epilogo2

		xor r9,r9
		mov r9w, WORD [r13 + r8 * 2] ;puntero al indice

		mov r10, QWORD [r12 + r9 *8 ] ; item
		mov QWORD [rax + r8 *8], r10 ; item en inventario
		inc r8
		jmp recorrerIndice

	epilogo2: 

		add rsp, 8
		pop r14
		pop r13
		pop r12
		pop rbp
	ret
