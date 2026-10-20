# Diccionario de métricas, supuestos y reglas

**Datos**: `bigquery-public-data.thelook_ecommerce` (SINTÉTICOS). Proyecto de trabajo: `<tu-proyecto>` (Sandbox, sin facturación).
**Ventana**: 2025-10-01 a 2026-09-30. El máximo `created_at` es 2026-10-23, así que octubre de 2026 es parcial y se excluye. El historial anterior (desde 2019) se usa solo para fijar la primera compra.

## Grano de las tablas
| Tabla | 1 fila = | Uso |
|---|---|---|
| order_items | 1 línea de pedido (id único) | Base de TODAS las ventas |
| orders | 1 pedido | Solo contraste (QC) |
| products | 1 producto (id único) | JOIN N:1 para categoría |
| users | 1 usuario (id único) | JOIN N:1 para país |
Los joins son N:1 desde order_items, así que no multiplican filas (validado: el total es idéntico con 0, 1 o 2 joins).

## Reglas de estado
Estados reales: Shipped, Complete, Processing, Cancelled, Returned.
| Indicador | Líneas incluidas |
|---|---|
| Ventas brutas, líneas, pedidos, compradores | status <> 'Cancelled' (incluye Processing y Shipped: pedido realizado, no necesariamente entregado ni cobrado) |
| Devoluciones | status = 'Returned' (subconjunto de lo anterior) |
| Clientes nuevos/recurrentes y cohortes | status <> 'Cancelled' |

## Métricas
| Métrica | Definición | Numerador / denominador |
|---|---|---|
| ventas_brutas | SUM(sale_price) | – |
| valor_devuelto | SUM(sale_price) de líneas Returned | – |
| neto_tras_devoluciones | ventas_brutas − valor_devuelto | **No es ingreso contable ni margen**: no hay costes, impuestos ni reembolsos reales; solo se resta el precio de venta de las líneas devueltas |
| pedidos | COUNT(DISTINCT order_id) no cancelados | No aditivo entre categorías (un pedido puede tener varias) |
| ticket_medio_bruto | ventas_brutas / pedidos | división segura (0 si no hay pedidos) |
| tasa_devolucion_unidades | líneas Returned / líneas no canceladas | |
| tasa_devolucion_valor | valor_devuelto / ventas_brutas | |
| clientes_activos | compradores distintos en el mes | |
| cliente nuevo (mes M) | primera compra no cancelada, sobre todo el historial, ocurre en M | |
| cliente recurrente (mes M) | compra en M y su primera compra fue antes | |
| pct_recurrentes | recurrentes / clientes_activos | |
| cohorte | mes de primera compra no cancelada | |
| actividad en k | clientes de la cohorte con compra en el mes cohorte+k / tamaño de cohorte | **No acumulada** |

## Decisiones y supuestos
1. Mes = mes de `created_at` de la línea. Las devoluciones se atribuyen al **mes de la venta**, no al de la devolución.
2. Meses sin actividad: la consulta mensual usa un calendario generado y devuelve 0 (en esta ventana no hubo ninguno).
3. Cohortes: la comparación entre cohortes usa el mismo k. Solo se calcula (cohorte, k) si ese mes ya ha ocurrido. El agregado por k promedia solo las cohortes observables en k, así que los k altos usan menos cohortes.
4. País = `users.country` (país del cliente, no del envío). Se mantienen `Spain` y `España` como etiquetas separadas, sin corregirlas.
5. Dashboard y Sheets: las medidas con filtro de país y categoría son aditivas (ventas, líneas, devueltas). Pedidos, ticket y clientes nuevos/recurrentes solo se ofrecen por mes (no son aditivos).
6. Datos sintéticos: no se pueden extraer conclusiones de negocio reales ni causales.
