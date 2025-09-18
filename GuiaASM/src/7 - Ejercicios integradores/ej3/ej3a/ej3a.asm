extern malloc


;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0
CASO_ESTADO_OFFSET EQU 4
CASO_USUARIO_OFFSET EQU 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7

;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)

; rdi = puntero incio caso a copiar
; rsi = puntero arr casos por nivel
copiarCasos: 
    push rbp
    mov rbp, rsp

    xor r8, r8
    recorrer3:
        cmp r8, 3
        je finRecorrer3

        mov cl, BYTE [rdi + r8+ CASO_CATEGORIA_OFFSET]
        mov BYTE [rsi + r8+ CASO_CATEGORIA_OFFSET], cl
        inc r8 
        jmp recorrer3

    finRecorrer3:
    mov cx, WORD [rdi + CASO_ESTADO_OFFSET]
    mov WORD [rsi + CASO_ESTADO_OFFSET], cx

    mov rcx, QWORD [rdi + CASO_USUARIO_OFFSET]
    mov QWORD [rsi + CASO_USUARIO_OFFSET], rcx

    pop rbp 
    ret 


global segmentar_casos
; rdi = arreglo_casos
; rsi = largo
segmentar_casos:
;PARECE QUE EL ERROR ESTÁ EN QUE PASA CUANDO NO HAY CASOS, TENGO QUE PONER EL PUNTERO A NULL

    push rbp ;alin
    mov rbp, rsp
    push r12
    push r13 ;alin
    push r14
    push r15 ;alin
    push rbx
    sub rsp, 8 ;alin

    ;preservo
    mov r12, rdi ; arreglo
    mov r13, rsi ; largo

    mov rax, CASO_SIZE
    mul r13
    mov r13, rax

    xor r14, r14 ;contador 0
    xor r15, r15 ; cont 1
    xor rbx, rbx ; cont 2

    xor r8, r8 ; indice arreglo (saltando casos)

    recorrerArreglo: 
        cmp r8, r13
        je finArreglo

        mov r9, QWORD [r12 + r8+ CASO_USUARIO_OFFSET ] ; usuario
        mov r10d, DWORD [r9 + USUARIO_NIVEL_OFFSET] ; nivel usuario

        cmp r10d, 1
        jg UsNivel2
        jl UsNivel0 

        ;USNivel1
        inc r15 ; inc contador 1
        jmp incIndex

        UsNivel2: 
            inc rbx ; inc contador 2
            jmp incIndex
        
        UsNivel0:
            inc r14 ; inc contador 0
            jmp incIndex
        
        incIndex:
            add r8, CASO_SIZE
            jmp recorrerArreglo

    finArreglo:

    ;ver si conteo0 tiene elem
    cmp r14, 0 
    je  verConteo1

    mov rax, CASO_SIZE
    mul r14  ; conteo * tam caso
    mov rdi, rax
    call malloc 
    mov r14, rax ; r14 -> puntero array 0

    verConteo1: 
        cmp r15, 0
        je verConteo2

        mov rax, CASO_SIZE
        mul r15   ; conteo * tam caso
        mov rdi, rax
        call malloc 
        mov r15, rax ; r15 -> puntero array 1

    verConteo2:
        cmp rbx, 0
        je finMallocArrays

        mov rax, CASO_SIZE
        mul rbx   ; conteo * tam caso
        mov rdi, rax
        call malloc 
        mov rbx, rax ; rbx -> puntero array 2

    finMallocArrays: 
    ;recorrer otra vez para copiar casos segun nivel

    xor r8, r8 ;indice array
    xor r9, r9 ;contador 0
    xor r10, r10 ; cont 1
    xor r11, r11 ; cont 2

     recorrerArreglo2: 
        cmp r8, r13
        je finArreglo2

        mov rdi, QWORD [r12 + r8 + CASO_USUARIO_OFFSET ] ; usuario
        mov esi, DWORD [rdi + USUARIO_NIVEL_OFFSET] ; nivel usuario

        ;preparar para llamar a copiarCasos
        push r8 ; rbp - 56
        push r9 ; rbp - 64
        push r10 ; rbp - 72
        push r11 ; rbp - 80

        add r8, r12 ; aprovecho que el valor se borra
        mov rdi, r8  ;puntero inicio caso

        ;mov rdi, QWORD [r12 + r8]

        cmp esi, 1
        jg UsNivel22
        jl UsNivel02

        ;USNivel1
        add r10, r15 
        mov rsi, r10
        call copiarCasos
        add QWORD [rbp - 72], CASO_SIZE ; inc contador 1
        jmp incIndex2

        UsNivel22: 
            add r11, rbx
            mov rsi, r11
            call copiarCasos
            add QWORD [rbp - 80], CASO_SIZE ; inc contador 1
            jmp incIndex2
        
        UsNivel02:
            add r9, r14
            mov rsi, r9
            call copiarCasos
            add  QWORD [rbp - 64], CASO_SIZE ; inc contador 0
            jmp incIndex2
        
        incIndex2:
            pop r11
            pop r10
            pop r9
            pop r8

            add r8, CASO_SIZE
            jmp recorrerArreglo2

    finArreglo2:

    mov rdi, SEGMENTACION_SIZE
    call malloc ; rax -> puntero segmentation

    ; pongo arrays
    mov QWORD [rax + SEGMENTACION_CASOS0_OFFSET], r14
    mov QWORD [rax + SEGMENTACION_CASOS1_OFFSET], r15
    mov QWORD [rax + SEGMENTACION_CASOS2_OFFSET], rbx
   
    epilogoA:
    add rsp, 8
    pop rbx 
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
