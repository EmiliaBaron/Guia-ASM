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

global calcular_estadisticas

;void calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id)
; rdi = arreglo casos
; rsi = largo
; rdx = id usuario
calcular_estadisticas:
    push rbp ;alin
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15 ;alin
    push rbx 
    sub rsp, 8

    ;preservo
    mov r12, rdi ; arreglo casos 
    mov r13, rsi ; largo
    mov r14, rdx ; id us

    mov rax, CASO_SIZE
    mul r13
    mov r13, rax ; r13 -> largo * tam caso

    xor r15, r15

    ;crear struct stadisticas

    mov rdi, ESTADISTICAS_SIZE
    call malloc 
    mov rbx, rax ; rbx puntero a estadisticas

    recorrerArrayC:
        cmp r15, r13

        cmp rdx, 0
        je contabilizarCaso:

        ;ver usuario caso
        mov r9, QWORD [r12 + r15 + CASO_USUARIO_OFFSET] ; usuario
        mov r10d, DWORD [r9 + USUARIO_ID_OFFSET] ;id suario

        cmp r14, r10d
        je contabilizarCaso
        jmp incrementIndexC

        contabilizarCaso:
            ;acceder a categoria
            mov rdi, r12
            add rdi, r15 
            add rdi, CASO_CATEGORIA_OFFSET ; rdi puntero a cat
            ;comparar CLT
            mov rsi, "CLT"

            push rsi  ; rbp - 56
            push rdi

            mov rsi, rbp 
            sub rsi, 56 

            call strcmp 

            pop rdi
            pop rsi 

            cmp rax, 0 
            je incrementarCLT

            ;comparar RBO
            mov rsi, "RBO"

            push rsi  ; rbp - 56
            push rdi

            mov rsi, rbp 
            sub rsi, 56 

            call strcmp 

            pop rdi
            pop rsi 

            cmp rax, 0 
            je incrementarRBO

            ;comparar KSC
            mov rsi, "KSC"

            push rsi  ; rbp - 56
            push rdi

            mov rsi, rbp 
            sub rsi, 56 

            call strcmp 

            pop rdi
            pop rsi 

            cmp rax, 0 
            je incrementarKSC

            ;comparar KDT
            mov rsi, "KDT"

            push rsi  ; rbp - 56
            push rdi

            mov rsi, rbp 
            sub rsi, 56 

            call strcmp 

            pop rdi
            pop rsi 

            cmp rax, 0 
            je incrementarKDT

            jmp verEstados

            incrementarCLT
                inc BYTE [rbx + ESTADISTICAS_CLT_OFFSET]
                jmp verEstados

            incrementarRBO
                inc BYTE [rbx + ESTADISTICAS_RBO_OFFSET]
                jmp verEstados
            
            incrementarKSC
                inc BYTE [rbx + ESTADISTICAS_KSC_OFFSET]
                jmp verEstados

            incrementarKDT
                inc BYTE [rbx + ESTADISTICAS_KDT_OFFSET]
                jmp verEstados
            
            verEstados: 
            ;acceder a estado
            cmp WORD []


        incrementIndexC:
            add r8, CASO_SIZE
            jmp recorrerArrayC

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
