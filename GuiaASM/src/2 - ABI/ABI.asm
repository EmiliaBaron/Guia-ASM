extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]

alternate_sum_8:
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
;- x5 --> EBX-  ; x5 --> R8D
; -x6 --> EAX-  ; x6 --> R9D   
; x7 --> [BP + 16] ->> por que es 16 y 24? No se está llevando solo 2B?
; x8 --> [BP + 24]
	;prologo
  push RBP 
  mov RBP, RSP

  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX
  add EDI, R8D
  sub EDI, R9D

  mov ESI, [RBP + 16]
  add EDI, ESI
  mov ESI, [RBP + 24]
  sub EDI, ESI

  mov eax, edi
	
	;epilogo
  pop rbp
	ret

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
; parametros: 
; desti --> EDI
; x1 --> ESI
; f1 --> EDX ??? ->> XMM0
product_2_f:
 ;prologo
 push rbp
 mov rbp, rsp

 ;convierto x1 a float
 CVTPI2PS XMM1, esi    ; la instruccion solo toma reg64 bits, pero si uso esos puede que esten 
                      ; sucios, y resetear todo el reg rsi a cero hace que pierda el valor x1
                      ; que hagoooo
 ;multiplico floats
 mulss XMM0, XMM1
                  ;fmul XMM0, XMM1 -> instruccion no válida
 ;convierto resultado a int truncando
 VCVTTSS2USI esi, XMM0
 ;paso a memoria
 mov [edi], esi

;  CVTDQ2PD esi, esi
;  mulpd  esi, edx 
;  CVTTSD2SI esi, esi 
;  mov [edi], esi 

 ;epilogo
 pop rbp
 ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: 
;  destination[rdi],
; x1[esi], f1[XMM0], 
; x2[edx], f2[XMM1], 
; x3[ecx], f3[XMM2], 
; x4[R8D], f4[XMM3]
;	x5[R9D], f5[XMM4], 
; x6[rbp + 16], f6[XMM5], 
; x7[rbp + 24], f7[XMM6],
; x8[rbp + 32], f8[XMM7],
; x9[rbp +40], f9[rbp + 48]

product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	CVTSS2SD XMM0, XMM0
  CVTSS2SD XMM1, XMM1
  CVTSS2SD XMM2, XMM2
  CVTSS2SD XMM3, XMM3
  CVTSS2SD XMM4, XMM4
  CVTSS2SD XMM5, XMM5
  CVTSS2SD XMM6, XMM6
  CVTSS2SD XMM7, XMM7
  push XMM7 ; ->> bp + 8 ? 
  CVTSS2SD XMM7, [rbp + 48]  ;--> f9[XMM7]

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
  MULSD XMM0, XMM1
  MULSD XMM0, XMM2
  MULSD XMM0, XMM3
  MULSD XMM0, XMM4
  MULSD XMM0, XMM5
  MULSD XMM0, XMM6
  MULSD XMM0, XMM7 ;-> resultado por f9
  pop XMM7 
  MULSD XMM0, XMM7 ; -> resultado por f8

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	CVTPI2PD XMM1, esi 
  MULSD XMM0, XMM1
  CVTSI2SD XMM1, edx
  MULSD XMM0, XMM1
  CVTSI2SD XMM1, ecx 
  MULSD XMM0, XMM1
  CVTSI2SD XMM1, r8d
  MULSD XMM0, XMM1
  CVTSI2SD XMM1, r9d 
  MULSD XMM0, XMM1

  mov XMM1, [rbp + 16]
  MULSD XMM0, XMM1
  mov XMM1, [rbp + 24]
  MULSD XMM0, XMM1
  mov XMM1, [rbp + 32]
  MULSD XMM0, XMM1
  mov XMM1, [rbp + 40]
  MULSD XMM0, XMM1

  mov [rdi], XMM0

	; epilogo
	pop rbp
	ret

