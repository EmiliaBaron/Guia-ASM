//*************************************
// Declaración de estructuras
//*************************************

// Lista de arreglos de enteros de 32 bits sin signo.
// next: Siguiente elemento de la lista o NULL si es el final
// categoria: Categoría del nodo
// arreglo: Arreglo de enteros
// longitud: Longitud del arreglo
typedef struct nodo_s
{
    struct nodo_s *next; // 8 => 0  asmdef_offset:NODO_OFFSET_NEXT
    uint8_t categoria;   // 1 => 8  (7 padding) asmdef_offset:NODO_OFFSET_CATEGORIA
    uint32_t *arreglo;   // 8 => 16  asmdef_offset:NODO_OFFSET_ARREGLO
    uint32_t longitud;   // 4 => 24      asmdef_offset:NODO_OFFSET_LONGITUD
} nodo_t;                // 32        asmdef_size:NODO_SIZE

typedef struct __attribute__((__packed__)) packed_nodo_s
{
    struct packed_nodo_s *next; // 8 => 0       asmdef_offset:PACKED_NODO_OFFSET_NEXT
    uint8_t categoria;          // 1 => 8       asmdef_offset:PACKED_NODO_OFFSET_CATEGORIA
    uint32_t *arreglo;          // 8 => 9       asmdef_offset:PACKED_NODO_OFFSET_ARREGLO
    uint32_t longitud;          // 4 => 17       asmdef_offset:PACKED_NODO_OFFSET_LONGITUD
} packed_nodo_t;                // 21       asmdef_size:PACKED_NODO_SIZE

// Puntero al primer nodo que encabeza la lista
typedef struct lista_s
{
    nodo_t *head; // 8 => 0     asmdef_offset:LISTA_OFFSET_HEAD
} lista_t;        // 8           asmdef_size:LISTA_SIZE

// Puntero al primer nodo que encabeza la lista
typedef struct __attribute__((__packed__)) packed_lista_s
{
    packed_nodo_t *head; // 8 => 0    asmdef_offset:PACKED_LISTA_OFFSET_HEAD
} packed_lista_t;        // 8         asmdef_size:PACKED_LISTA_SIZE

// jk