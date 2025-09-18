#include "../ejs.h"

// Función auxiliar para contar casos por nivel
void contar_casos_por_nivel(caso_t *arreglo_casos, int largo, int *contadores)
{
    for (int i = 0; i < largo; i++)
    {
        caso_t caso = arreglo_casos[i];
        usuario_t *usuario = caso.usuario;

        switch (usuario->nivel)
        {
        case 0:
            contadores[0]++;
            break;
        case 1:
            contadores[1]++;
            break;
        case 2:
            contadores[2]++;
            break;
        }
    }
}

segmentacion_t *segmentar_casos(caso_t *arreglo_casos, int largo) // arreglo casos arreglo de punteros a casos
{
    int *contadores = malloc(3);
    contar_casos_por_nivel(arreglo_casos, largo, contadores);

    segmentacion_t *segmentacion = (segmentacion_t *)malloc(24); // un puntero a struct de tres punteros

    // segmentacion->casos_nivel_0 = malloc(contadores[0] * sizeof(caso_t));
    // segmentacion->casos_nivel_1 = malloc(contadores[1] * sizeof(caso_t));
    // segmentacion->casos_nivel_2 = malloc(contadores[2] * sizeof(caso_t));

    if (contadores[0] != 0)
    {
        segmentacion->casos_nivel_0 = (caso_t *)malloc(contadores[0] * sizeof(caso_t));
    }
    else
    {
        segmentacion->casos_nivel_0 = NULL;
    }

    if (contadores[1] != 0)
    {
        segmentacion->casos_nivel_1 = (caso_t *)malloc(contadores[1] * sizeof(caso_t));
    }
    else
    {
        segmentacion->casos_nivel_1 = NULL;
    }

    if (contadores[2] != 0)
    {
        segmentacion->casos_nivel_2 = (caso_t *)malloc(contadores[2] * sizeof(caso_t));
    }
    else
    {
        segmentacion->casos_nivel_2 = NULL;
    }

    free(contadores);

    for (int i = 0; i < largo; i++)
    {
        caso_t caso = arreglo_casos[i];
        usuario_t *usuario = caso.usuario;

        int j = 0;
        int k = 0;
        int l = 0;

        switch (usuario->nivel)
        {
        case 0:
            segmentacion->casos_nivel_0[j] = caso;
            j++;
            break;
        case 1:
            segmentacion->casos_nivel_1[k] = caso;
            k++;
            break;
        case 2:
            segmentacion->casos_nivel_2[l] = caso;
            l++;
            break;
        }
    }

    return segmentacion;
}
