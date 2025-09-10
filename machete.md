Vamos a dividir los registros entre
- ***no volátiles*** o ***callee-saved***: la función llamada debe encargarse de que, al terminar, estos registros tengan los mismos valores que al comienzo. Estos son:
  
  - En 64 bits: RBX, RBP, R12, R13, R14, R15.
  - En 32 bits: EBX, EBP, ESI, EDI
  
- ***volátiles*** o ***caller-saved*** : la función llamada no tiene obligación de conservarlos, si los quiere debe conservalos la función llamadora. 

NOTA: estamos programando en 64, los registros no volátiles son los de 64 bits, EDI y ESI son los 32 bits menos significativos del los registros RDI Y RSI que son volátiles en 64 bits
Y los registros EDX y ECX te los guardas porque la funcion a la que llamas te lo pueden escribir sin preservarlos porque son volátiles

Menciones especiales: 

- RSP/ESP se puede considerar como un registro no volátil dada su función específica como tope de la pila.
- R10 y R11 no están ni en el grupo de los registros por los que se pasan parámetros ni en el grupo de los registros no volátiles, no se olviden de su existencia.
- XMM8 a XMM15 no están en el grupo de los registros por los que se pasan parámetros pero están a disposición, no se olviden de su existencia.

PARAMETROS
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
; x5 --> R8D
; x6 --> R9D
; x7 --> [rpb + 16]
; x8 --> [rpb + 24]

 x6[rbp + 16], f6[XMM5], 
; x7[rbp + 24], f7[XMM6],
; x8[rbp + 32], f8[XMM7],
; x9[rbp +40], f9[rbp + 48]



instrucciones usadas 
add 
sub 

