# Registro de controles de calidad (ejecutados en BigQuery el 2026-10-20)
Todos corren sobre el historial completo salvo indicación. Detalle también en la hoja `qc_log`.
| Control | Resultado | Estado |
|---|---|---|
| order_items id duplicado | 0 | OK |
| order_items filas | 181.978 (2019-01 a 2026-10-23) | info |
| sale_price nulo o ≤0 | 0 | OK |
| Líneas sin pedido / sin producto / sin usuario | 0 / 0 / 0 | OK |
| orders / products / users id duplicado | 0 / 0 / 0 | OK |
| Returned sin returned_at; returned_at sin Returned | 0 / 0 | OK |
| **returned_at < created_at** | **673** | **Anomalía sintética.** No afecta a ventas ni a tasas (se usa status). No se calcula plazo de devolución |
| user_id y status de la línea ≠ pedido | 0 / 0 | OK |
| users.country nulo/vacío; products.category nula | 0 / 0 | OK |
| **Línea creada antes que el alta del usuario** | **160** | Anomalía menor (0,09%). Se mantienen |
| Total ventana: items vs join products vs join users vs ambos | 3.260.577,46 en las cuatro vías (54.753 líneas) | OK: los joins no duplican |
| Suma 12 meses vs total ventana (ventas y devuelto) | 3.260.577,46 y 377.565,28 (suma recalculada a mano) | OK |
| Suma por país vs total | 3.260.577,46 (suma recalculada a mano) | OK |
| Clientes nuevos + recurrentes = compradores mensuales | coincide los 12 meses | OK |
| Pooled de cohortes en Sheets vs JSON de BigQuery | coinciden (8,13 %, 5,15 %, 4,72 %…) | OK |
| **Pedidos no cancelados: orders vs order_items** | 37.819 vs 37.846 (27 de diferencia, 0,07 %) | **Diferencia menor, causa NO verificada** (hipótesis: created_at distinto entre tablas en los bordes de mes) |
| **Líneas: SUM(orders.num_of_item) vs COUNT(order_items)** | 54.897 vs 54.753 (144 de diferencia, 0,26 %) | **Diferencia menor, causa NO verificada.** Se usa order_items |
| Etiquetas de país | `Spain` y `España` coexisten (2 líneas en `España`); `Brasil` en español | Aviso. Sin impacto material |
| Suma de las 26 categorías y de los 15 países vs total ventana | 3.260.577,46 / 54.753 líneas / 6.420 devueltas; países: 37.846 pedidos | OK (fórmulas SUM en las hojas) |
| Hoja `fact_mes_pais_categoria` (3.283 filas) vs total ventana | ventas 3.260.577,46; devuelto 377.565,28; líneas 54.753 | OK (fórmulas vivas en `qc_log`) |

Coste: consultas de 6,99 MB a 10 MB cada una (cuota Sandbox). No se activó facturación.
