#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_2A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_2B_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_2C_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa, attackunit_t *compartida, uint32_t (*fun_hash)(attackunit_t *))
{
    uint32_t hashCompartida = fun_hash(compartida);

    for (int i = 0; i < 255; i++)
    {
        for (int j = 0; j < 255; j++)
        {
            attackunit_t *puntero = mapa[i][j];
            if (puntero)
            {
                uint32_t hashPuntero = fun_hash(puntero);

                if (hashPuntero == hashCompartida)
                {
                    mapa[i][j] = compartida;

                    puntero->references--;
                    compartida->references++;

                    if (puntero->references == 0)
                    {
                        free(puntero);
                    }
                }
            }
        }
    }
}

/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char *))
{
    uint32_t reserva = 0;

    for (int i = 0; i < 255; i++)
    {
        for (int j = 0; j < 255; j++)
        {
            attackunit_t *puntero = mapa[i][j];
            if (puntero)
            {
                uint16_t combustibleBase = puntero->combustible;
                puntero->combustible = fun_combustible(puntero->clase);
                reserva += (combustibleBase - puntero->combustible);
            }
        }
    }
    return reserva;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t *))
{
    attackunit_t *puntero = mapa[x][y];

    if (puntero)
    {
        uint8_t referencias = puntero->references;

        if (referencias > 1)
        {
            puntero->references--;

            attackunit_t *nuevoPuntero = malloc(sizeof(attackunit_t));

            for (int i = 0; i < 11; i++)
            { // copio clase
                nuevoPuntero->clase[i] = puntero->clase[i];
            }

            nuevoPuntero->combustible = puntero->combustible; // combustible

            nuevoPuntero->references = 1; // referencias

            mapa[x][y] = nuevoPuntero;

            fun_modificar(nuevoPuntero);
        }
        else
        { // asumo que si no es ref>1 es ref =1
            fun_modificar(puntero);
        }
    }
}
