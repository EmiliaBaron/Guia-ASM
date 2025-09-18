extern strcmp

extern memcpy

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

global resolver_automaticamente

;void resolver_automaticamente(funcionCierraCasos* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo)
resolver_automaticamente:
;parametros
; rdi = funcion
; rsi = arreglo casos
; rdx = casos a revisar
; rcx = largo
    push rbp 
    mov rbp, rsp
    push r12
    push r13
    push r14 
    push r15
    push rbx
    sub rsp, 8

    ; preservo
    mov r12, rdi ; funcion
    mov r13, rsi ; arreglo casos
    mov r14, rdx ; casos revisar
    mov r15, rcx ; largo

    mov rax, CASO_SIZE
    mul r15
    mov r15, rax ; largo * tam caso
    
    xor rbx, rbx ; indice
    xor r11, r11 ; INDICE CASOS A REVISAR -> PRESERVARLOO

    recorrerArrayB: 
        cmp rbx, r15
        je finRecorrerB

        mov r8, QWORD [r13 + rbx + CASO_USUARIO_OFFSET ] ; usuario
        mov r10d, DWORD [r8 + USUARIO_NIVEL_OFFSET] ; nivel usuario

        cmp r10d, 0
        je agregarARevisar

        mov rdi, r13
        add rdi, rbx ;-> rdi puntero al caso

        push r11
        sub rsp, 8

        call r12 ; funcion IA rax -> 

        add rsp, 8 
        pop r11

        cmp rax, 1 ; si res es 1
        je cerradoFavorablemente

        cmp rax, 0 ; si res NO es 0
        jne agregarARevisar

        chequearCategoria: ; si res es 0
            mov rdi, r13
            add rdi, rbx
            ;add rdi, CASO_CATEGORIA_OFFSET ; rdi -> puntero a categoria

            mov rsi, "CLT"
            push rsi ; [rbp - 56]
            mov rsi, rbp 
            sub rsi, 56 ; rsi -> dir "clt" en stack

            ;mov rdx, 3
            ;chequear cat = clt
            push rdi
            push r11
            sub rsp, 8

            call strcmp ; rax -> 0 1 o -1

            add rsp, 8
            pop r11
            pop rdi
            pop rsi

            cmp rax, 0
            je cerradoDesfavorablemente

            ;chequear si no es RBO
            mov rsi, "RBO"
            push rsi ; [rbp - 56]
            mov rsi, rbp 
            sub rsi, 56 ; rsi -> dir "rbo" en stack

            ;mov rdx, 3

            push r11

            call strcmp ; rax -> 0 1 o -1

            pop r11
            pop rsi

            cmp rax, 0
            jne agregarARevisar ; si no es clt ni rbo
            ; si era ,cerrado desf

            cerradoDesfavorablemente:
                mov WORD [r13 + rbx + CASO_ESTADO_OFFSET], 2
                jmp incIndex     


        cerradoFavorablemente: 
            mov WORD [r13 + rbx + CASO_ESTADO_OFFSET], 1
            jmp incIndex

        agregarARevisar:
            mov rdi, r14
            add rdi, r11 ; rdi -> puntero a siguente de casos a revisar

            mov rsi, r13
            add rsi, rbx ; rsi -> puntero a caso actual de arr casos

            mov rdx, CASO_SIZE

            push r11
            sub rsp, 8

            call memcpy ; rax -> 0 1 o -1

            add rsp, 8
            pop r11

            add r11, CASO_SIZE            

    incIndex:
        add rbx, CASO_SIZE
        jmp recorrerArrayB


    finRecorrerB:

    add rsp, 8
    pop rbx
    pop r12
    pop r13
    pop r14
    pop r15
    pop rbp
    ret
